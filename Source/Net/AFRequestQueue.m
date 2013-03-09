
#import "AFRequestQueue.h"

#import "AFPerformSelectorOperation.h"
#import "AFHeaderRequest.h"
#import "AFLogger.h"

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
    queuePosition = 1;
    [activatedRequests removeAllObjects];
    @synchronized (queue)
    {
        bool
            requestWasActioned,
            requestIsAlreadyActive,
            maxRequestsReached;

        for( AFRequest* request in queue )
        {
            NSAssert( request.state == AFRequestStateQueued, @"All requests in the queue should be 'pending', but found one which was marked " );

            requestIsAlreadyActive = [activeRequests containsObject:request];

            if( requestIsAlreadyActive )
            {
                [queue removeObject:request];
            }
            else
            {
                maxRequestsReached = [activeRequests count] >= maxConcurrentDownloads;

                if( !maxRequestsReached )
                {
                    requestWasActioned = [self actionRequest:request];

                    if( requestWasActioned )
                    {
                        [activeRequests    addObject:request];
                        [activatedRequests addObject:request];
                    }
                }
                else
                {
                    if ([request isKindOfClass:[AFRequest class]])[request requestWasQueuedAtPosition:queuePosition];
                    queuePosition++;
                }
            }
        }
        for (AFRequest* request in activatedRequests)[queue removeObject:request];
    }
}

- (BOOL)actionRequest:(AFRequest*)request
{
    if(targetHandler) return [targetHandler handleRequest:request];
    else
    {
        [self performSelectorOnMainThread:@selector(startConnectionMainThreadInternal:)
                               withObject:request
                            waitUntilDone:NO
                                    modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        return YES;
    }
}

/**
 *	Cancels all requests in this queue
 */
- (void)cancelAllRequests
{
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
    AFLogPosition();

#ifdef BACKGROUND_HANDLING_ENABLED
    [self performSelectorOnCommonBackgroundThread:@selector(handleRequestInternal:) withObject:request];
    return YES;
#else
		return [self handleRequestInternal:storeKitRequest];
	#endif
}

- (BOOL)handleRequestInternal:(AFRequest*)request
{
    AFLogPosition();

#ifdef BACKGROUND_HANDLING_ENABLED
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif

    BOOL returnVal;
    if( request && request.state != AFRequestStateFulfilled )
    {
        [self queueRequestAtBack:request];
        returnVal = YES;
    }
    else returnVal = NO;

#ifdef BACKGROUND_HANDLING_ENABLED
    [pool release];
#endif

    return returnVal;
}

- (void)queueRequestAtFront:(AFRequest*)requestIn
{
    [self queueRequest:requestIn atPosition:0];
}

- (void)queueRequestAtBack:(AFRequest*)requestIn;
{
    [self queueRequest:requestIn atPosition:[queue count]];
}

/**
 *	Adds a request to the back of the request queue
 */
- (void)queueRequest:(AFRequest*)requestIn atPosition:(NSUInteger)positionIn
{
    NSAssert(requestIn, NSInvalidArgumentException);

    [requestIn addObserver:self];
    [queue insertObject:requestIn atIndex:positionIn];
    [requestIn requestWasQueuedAtPosition:positionIn];
    [self startWaitingRequests];
}

- (void)startConnectionMainThreadInternal:(AFRequest*)requestIn
{
    NSAssert(requestIn, NSInvalidArgumentException);

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestIn.URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    urlRequest = [requestIn willSendURLRequest:urlRequest];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];

    requestIn.connection = connection;
}

- (void)requestComplete:(AFRequest*)requestIn
{
    NSAssert(requestIn, NSInvalidArgumentException);

    if(![requestIn isKindOfClass:[AFHeaderRequest class]]) NSLog(@"Not an AFHeaderRequest");
    if(![requestIn isKindOfClass:[AFRequest class]]) NSLog(@"Not an AFRequest");
    if(![requestIn respondsToSelector:@selector(removeObserver:)]) NSLog(@"Doesn't respond to removeObserver:");
    NSLog(@"Is a: %@", NSStringFromClass([requestIn class]));

    [requestIn removeObserver:self];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestCancelled:(AFRequest*)requestIn
{
    AFLogPosition();
    NSAssert(requestIn, NSInvalidArgumentException);
    [self requestWasDeactivatedInternal:requestIn];
}

- (void)requestFailed:(AFRequest*)requestIn withError:(NSError*)error
{
    AFLogPosition();
    NSAssert(requestIn, NSInvalidArgumentException);
    [self requestWasDeactivatedInternal:requestIn];
}

-(void)requestWasDeactivatedInternal:(AFRequest*)requestIn
{
    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (AFRequest*)queuedRequestForConnection:(NSURLConnection *)connection
{
    NSAssert(connection, NSInvalidArgumentException);

    for (AFRequest*testRequest in queue)            if (testRequest.connection == connection) return testRequest;
    for (AFRequest*testRequest in activeRequests)   if (testRequest.connection == connection) return testRequest;
    return nil;
}

- (void)setOffline:(BOOL)offline
{
    if (!offline)
    {
        //NSLog(@"Going ONLINE from being offine... start waiting requests.");
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
    NSAssert(connection, NSInvalidArgumentException);
    NSAssert(response,   NSInvalidArgumentException);

    AFRequest* findRequest = [[self queuedRequestForConnection:connection] retain];

    NSString *responseString = [NSString stringWithFormat:@"Couldn't find the request that I received a response to! %@", [[response URL] absoluteString]];
    NSAssert ( findRequest, responseString );

    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headers = [[httpResponse allHeaderFields] retain];

    [findRequest willReceiveWithHeaders:headers responseCode:[httpResponse statusCode]];

    [headers release];
    [findRequest release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSAssert(connection, NSInvalidArgumentException);
    NSAssert(data,       NSInvalidArgumentException);

    AFRequest*findRequest = [self queuedRequestForConnection:connection];
    if (findRequest) [findRequest received:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSAssert(connection, NSInvalidArgumentException);
    //[self setOffline:YES];
    AFRequest* findRequest = [self queuedRequestForConnection:connection];
    NSAssert(findRequest, @"Couldn't find the request for connection in %@", [self class], nil);
    [findRequest didFail:error];
    //[connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSAssert(connection, NSInvalidArgumentException);

    AFRequest*findRequest = [[self queuedRequestForConnection:connection] retain];

    //NSAssert(findRequest,@"Couldn't retrieve request for AFRequestEventFinished connection");

    [findRequest didFinish]; //Tell the object that it AFRequestEventFinished (so it can do something useful with the data)
    [findRequest removeObserver:self]; //Stop listening to the request
    [queue removeObject:findRequest]; //Remove the request from the list
    [self startWaitingRequests];

    [findRequest release];
    [connection autorelease];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

    if (redirectResponse)
    {
    }
    return request; //Currently always allowing the redirection, by returning the request value
}

// End NSURLConnectionDelegate methods

- (void)dealloc
{
    [activeRequests release];
    [self cancelAllRequests];
    for (AFRequest* request in queue)[request removeObserver:self];
    [queue release];
    [activatedRequests release];
    [super dealloc];
}

@synthesize queue, activeRequests;

@end
