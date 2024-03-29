
#import "AFRequestQueue.h"

#import "AFLog.h"
#import "AFAssertion.h"
#import "AFDispatch.h"

@interface AFRequestQueue ()

- (BOOL)handleRequestInternal:(AFRequest*)request;
-(void)queueRequest:(AFRequest *)requestIn atPosition:(NSUInteger)positionIn;

-(void)requestWasDeactivatedInternal:(AFRequest *)requestIn;
@end

@implementation AFRequestQueue
{
    NSMutableArray *queue;
    NSMutableSet   *activeRequests;
    NSMutableSet   *activatedRequests;
    NSUInteger queuePosition;
    NSObject <AFRequestHandler> *targetHandler;
    int maxConcurrentDownloads;

	#ifdef THREADED_REQUEST_HANDLER_ENABLED
	NSCondition* requestThreadCondition;
	NSThread* requestThread;
	#endif
}

- (id)initWithTargetHandler:(NSObject <AFRequestHandler> *)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn
{
    self = [super init];
    if (self)
    {
        targetHandler          = targetHandlerIn;
        queue                  = [[NSMutableArray alloc] init];
        activeRequests         = [[NSMutableSet alloc] init];
        activatedRequests      = [[NSMutableSet alloc] init];
        maxConcurrentDownloads = maxConcurrentDownloadsIn;
    }
    return self;
}

- (void)startWaitingRequests
{
	AFAssertBackgroundThread();

    queuePosition = 1;
    [activatedRequests removeAllObjects];
    @synchronized (queue)
    {
        bool
            requestWasActioned,
            requestIsAlreadyActive,
            maxRequestsReached;

	    AFLogPosition(@"State of request queue is:");

	    int i=0;
        for( AFRequest* request in queue )
        {
            NSAssert( request.state == AFRequestStateQueued, @"All requests in the queue should be 'pending', but found one which was marked " );

            requestIsAlreadyActive = [activeRequests containsObject:request];

            if( requestIsAlreadyActive )
            {
	            NSLog(@"%i - %@ - Already active",i++,request);

                [activatedRequests removeObject:request];
            }
            else
            {
                maxRequestsReached = [activeRequests count] >= maxConcurrentDownloads;

                if( !maxRequestsReached )
                {
	                NSLog(@"%i - %@ - Activating",i++,request);

                    requestWasActioned = [self actionRequest:request];

                    if( requestWasActioned )
                    {
                        [activeRequests    addObject:request];
                        [activatedRequests addObject:request];
                    }
                }
                else
                {
	                NSLog(@"%i - %@ - Queued",i++,request);

                    if ([request isKindOfClass:[AFRequest class]])
                    {
	                    [request requestWasQueuedAtPosition:queuePosition];
                    }
                    queuePosition++;
                }
            }
        }
        for (AFRequest* request in activatedRequests)[queue removeObject:request];
    }
}

- (BOOL)actionRequest:(AFRequest*)request
{
	AFAssertBackgroundThread();

    if(targetHandler) return [targetHandler handleRequest:request];
    else
    {
	    [self startConnectionInternal:request];
        return YES;
    }
}

/**
 *	Cancels all requests in this queue
 */
- (void)cancelAllRequests
{
	AFAssertBackgroundThread();

    for (AFRequest* request in [NSArray arrayWithArray:queue])
    {
        [request cancel];
    }
}

/**
 *	Same as calling 
 */
- (BOOL)handleRequest:(AFRequest*)request
{
	AFAssertBackgroundThread();
    AFLogPosition();

#ifdef BACKGROUND_HANDLING_ENABLED
	[self handleRequestInternal:request];

    return YES;
#else
		return [self handleRequestInternal:storeKitRequest];
	#endif
}

- (BOOL)handleRequestInternal:(AFRequest*)request
{
	AFAssertBackgroundThread();
    AFLogPosition();

#ifdef BACKGROUND_HANDLING_ENABLED
    @autoreleasepool {
#endif

        BOOL returnVal;
        if( request && request.state != AFRequestStateFulfilled )
        {
            [self queueRequestAtBack:request];
            returnVal = YES;
        }
        else returnVal = NO;

#ifdef BACKGROUND_HANDLING_ENABLED
#endif

        return returnVal;
    }
}

- (void)queueRequestAtFront:(AFRequest*)requestIn
{
	AFAssertBackgroundThread();

    [self queueRequest:requestIn atPosition:0];
}

- (void)queueRequestAtBack:(AFRequest*)requestIn;
{
	AFAssertBackgroundThread();

    [self queueRequest:requestIn atPosition:[queue count]];
}

/**
 *	Adds a request to the back of the request queue
 */
- (void)queueRequest:(AFRequest*)requestIn atPosition:(NSUInteger)positionIn
{
	AFAssertBackgroundThread();
    NSAssert(requestIn, NSInvalidArgumentException);

    [requestIn addObserver:self];
    [queue insertObject:requestIn atIndex:positionIn];
    [requestIn requestWasQueuedAtPosition:positionIn];
    [self startWaitingRequests];
}

- (void)startConnectionInternal:(AFRequest*)requestIn
{
	AFAssertBackgroundThread();
    NSAssert(requestIn, NSInvalidArgumentException);

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestIn.URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    urlRequest = [requestIn willSendURLRequest:urlRequest];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
    requestIn.connection = connection;
	[connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	[connection start];
}

- (void)requestComplete:(AFRequest*)requestIn
{
	AFAssertBackgroundThread();
    NSAssert(requestIn, NSInvalidArgumentException);

    [requestIn removeObserver:self];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestCancelled:(AFRequest*)requestIn
{
	AFAssertBackgroundThread();
    NSAssert(requestIn, NSInvalidArgumentException);
    [self requestWasDeactivatedInternal:requestIn];
}

- (void)requestFailed:(AFRequest*)requestIn withError:(NSError*)error
{
	AFAssertBackgroundThread();
    NSAssert(requestIn, NSInvalidArgumentException);
    [self requestWasDeactivatedInternal:requestIn];
}

-(void)requestWasDeactivatedInternal:(AFRequest*)requestIn
{
	AFAssertBackgroundThread();
    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (AFRequest*)queuedRequestForConnection:(NSURLConnection *)connection
{
	AFAssertBackgroundThread();
    NSAssert(connection, NSInvalidArgumentException);

    for (AFRequest*testRequest in queue)            if (testRequest.connection == connection) return testRequest;
    for (AFRequest*testRequest in activeRequests)   if (testRequest.connection == connection) return testRequest;
    return nil;
}

- (void)setOffline:(BOOL)offline
{
    if (!offline)
    {
        [self startWaitingRequests];
    }
}

- (BOOL)isRequestActive:(AFRequest*)requestIn
{
    NSAssert(requestIn, NSInvalidArgumentException);

    return [activeRequests containsObject:requestIn];
}

// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	AFAssertMainThread();
    NSAssert(connection, NSInvalidArgumentException);
    NSAssert(response,   NSInvalidArgumentException);

	dispatch_block_t action = ^
	{
	    AFRequest* findRequest = [self queuedRequestForConnection:connection];

	    NSString *responseString = [NSString stringWithFormat:@"Couldn't find the request that I received a response to! %@", [[response URL] absoluteString]];
	    NSAssert ( findRequest, responseString );

	    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
	    NSDictionary *headers = [httpResponse allHeaderFields];

	    [findRequest willReceiveWithHeaders:headers responseCode:[httpResponse statusCode]];

	};

	AFBeginBackgroundDispatch( action );
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	AFAssertMainThread();
    NSAssert(connection, NSInvalidArgumentException);
    NSAssert(data,       NSInvalidArgumentException);

	dispatch_block_t handOff = ^
	{
		AFRequest*findRequest = [self queuedRequestForConnection:connection];
		if (findRequest) [findRequest received:data];
	};

	AFBeginBackgroundDispatch( handOff );
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	AFAssertMainThread();
    NSAssert(connection, NSInvalidArgumentException);

	dispatch_block_t handOff = ^
	{
		AFRequest* findRequest = [self queuedRequestForConnection:connection];
		NSAssert(findRequest, @"Couldn't find the request for connection in %@", [self class], nil);
		[findRequest didFail:error];
	};

	AFBeginBackgroundDispatch( handOff );
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	AFAssertMainThread();
    NSAssert(connection, NSInvalidArgumentException);

	dispatch_block_t handOff = ^
	{
		AFRequest*findRequest = [self queuedRequestForConnection:connection];

		//NSAssert(findRequest,@"Couldn't retrieve request for AFRequestEventFinished connection");

		[findRequest didFinish]; //Tell the object that it AFRequestEventFinished (so it can do something useful with the data)
		[findRequest removeObserver:self]; //Stop listening to the request
		[queue removeObject:findRequest]; //Remove the request from the list
		[self startWaitingRequests];

		//[connection autorelease];
	};

	AFBeginBackgroundDispatch( handOff );
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
	//AFAssertBackgroundThread();

    return request; //Currently always allowing the redirection, by returning the request value
}

// End NSURLConnectionDelegate methods

- (void)dealloc
{
    [self cancelAllRequests];
    for (AFRequest* request in queue)[request removeObserver:self];
}

@synthesize queue, activeRequests;

@end
