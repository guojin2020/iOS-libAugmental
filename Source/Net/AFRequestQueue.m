#import "AFObservable.h"
#import "AFRequestQueue.h"
#import "AFPerformSelectorOperation.h"

@interface AFRequestQueue ()

- (BOOL)handleRequestInternal:(AFQueueableRequest*)request;

@end

@implementation AFRequestQueue
{
    NSMutableArray *queue;
    NSMutableSet   *activeRequests;
    NSMutableSet   *activatedRequests;
    int queuePosition;
    NSObject <AFRequestHandler> *targetHandler;
    int maxConcurrentDownloads;

    BOOL keepProcessing;

#ifdef THREADED_REQUEST_HANDLER_ENABLED
	NSCondition* requestThreadCondition;
	NSThread* requestThread;
	#endif
}

- (id)initWithTargetHandler:(NSObject <AFRequestHandler> *)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn
{
    if ((self = [super init]))
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
    //if(!offline)
    //{        
    queuePosition = 1;
    [activatedRequests removeAllObjects];
    @synchronized (queue)
    {
        for (AFQueueableRequest* request in queue)
        {
            if (request.state == (AFRequestState) AFRequestStatePending)
            {
                if ([activeRequests count] < maxConcurrentDownloads)
                {
                    if (![activeRequests containsObject:request])
                    {
                        if ([self actionRequest:request])
                        {
                            [activeRequests addObject:request];
                            [activatedRequests addObject:request];
                        }
                    }
                }
                else
                {
                    if ([request isKindOfClass:[AFQueueableRequest class]])[(AFQueueableRequest *)request requestWasQueuedAtPosition:queuePosition];
                    queuePosition++;
                }
            }
        }
        for (AFQueueableRequest* request in activatedRequests)[queue removeObject:request];
    }
}

- (BOOL)actionRequest:(AFRequest*)request
{
    if(targetHandler) return [targetHandler handleRequest:request];
    else
    {
        [self performSelectorOnMainThread:@selector(startConnectionMainThreadInternal:) withObject:request waitUntilDone:NO modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        return YES;
    }
}

/**
 *	Cancels all requests in this queue
 */
- (void)cancelAllRequests
{
    for (AFQueueableRequest* request in [NSArray arrayWithArray:queue])
    {
        [request cancel];
    }
}

/**
 *	Same as calling 
 */
- (BOOL)handleRequest:(AFRequest*)request
{
#ifdef BACKGROUND_HANDLING_ENABLED
    [self performSelectorOnCommonBackgroundThread:@selector(handleRequestInternal:) withObject:request];
    return YES;
#else
		return [self handleRequestInternal:storeKitRequest];
	#endif
}

- (BOOL)handleRequestInternal:(AFQueueableRequest*)request
{
    //NSLog(@"Handing request: %@",request);

#ifdef BACKGROUND_HANDLING_ENABLED
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif

    BOOL returnVal;
    if (request && request.state != (AFRequestState) AFRequestStateFulfilled)
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

/**
 *	Adds a request to the back of the request queue
 */
- (void)queueRequestAtFront:(AFQueueableRequest*)requestIn
{
    [requestIn addObserver:self];
    [queue insertObject:requestIn atIndex:0];
    [self startWaitingRequests];
}

- (void)queueRequestAtBack:(AFQueueableRequest*)requestIn;
{
    [requestIn addObserver:self];
    [queue addObject:requestIn];
    [self startWaitingRequests];
}

- (void)startConnectionMainThreadInternal:(AFRequest*)request
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    urlRequest = [request willSendURLRequest:urlRequest];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    request.connection = connection;
    //[connection release];
}

- (void)requestSizePolled:(int)sizeBytes forRequest:(AFRequest*)requestIn
{}

- (void)requestStarted:(AFRequest*)requestIn
{}

- (void)requestProgressUpdated:(float)completion forRequest:(AFRequest*)requestIn
{}

- (void)requestComplete:(AFRequest*)requestIn
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestCancelled:(AFRequest*)requestIn
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];

    if([requestIn isKindOfClass:[AFQueueableRequest class]])
    {
        [((AFQueueableRequest*)requestIn) requestWasUnqueued];
    }

    [self startWaitingRequests];
}

- (void)requestReset:(AFRequest*)requestIn //Same behaviour as AFRequestEventCancel (dequeue)
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestFailed:(AFRequest*)requestIn;
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (AFRequest*)queuedRequestForConnection:(NSURLConnection *)connection
{
    for (AFRequest*testRequest in queue) if (testRequest.connection == connection) return testRequest;
    for (AFRequest*testRequest in activeRequests) if (testRequest.connection == connection) return testRequest;
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

- (BOOL)isRequestActive:(AFRequest*)request
{return [activeRequests containsObject:request];}

// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    AFRequest*findRequest = [self queuedRequestForConnection:connection];

    NSString *responseString = [NSString stringWithFormat:@"Couldn't find the request that I received a response to! %@", [[response URL] absoluteString]];
    NSAssert(findRequest != nil, responseString);

    [findRequest willReceiveWithHeaders:[((NSHTTPURLResponse *) response) allHeaderFields] responseCode:[((NSHTTPURLResponse *) response) statusCode]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

    AFRequest*findRequest = [self queuedRequestForConnection:connection];
    if (findRequest) [findRequest received:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

    AFRequest*findRequest;

    //[self setOffline:YES];

    NSAssert(findRequest = [self queuedRequestForConnection:connection], @"Couldn't find the request for connection in %@", [self class]);

    [findRequest didFail:error];

    //[connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

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

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

// End NSURLConnectionDelegate methods

- (void)dealloc
{
    [activeRequests release];
    [self cancelAllRequests];
    for (AFQueueableRequest* request in queue)[request removeObserver:self];
    [queue release];
    [activatedRequests release];
    [super dealloc];
}

@synthesize queue, activeRequests;

@end
