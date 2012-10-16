#import "AFRequestQueue.h"
#import "AFPerformSelectorOperation.h"

@interface AFRequestQueue ()

- (BOOL)handleRequestInternal:(NSObject <AFQueueableRequest> *)request;

@end

@implementation AFRequestQueue

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
        for (NSObject <AFQueueableRequest> *request in queue)
        {
            if (request.state == (requestState) pending)
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
                    if ([request respondsToSelector:@selector(requestQueuedAtPosition:)])[request requestQueuedAtPosition:queuePosition];
                    queuePosition++;
                }
            }
        }
        for (NSObject <AFQueueableRequest> *request in activatedRequests)[queue removeObject:request];
    }
    //}
    //else
    //{
    //    //NSLog(@"Warning: %@ was called while we were offline!",NSStringFromSelector(_cmd));
    //}
}

- (BOOL)actionRequest:(NSObject <AFRequest> *)request
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
{for (NSObject <AFQueueableRequest> *request in [NSArray arrayWithArray:queue])if (request)[request cancel];}

/**
 *	Same as calling 
 */
- (BOOL)handleRequest:(NSObject <AFRequest> *)request
{
#ifdef BACKGROUND_HANDLING_ENABLED
    [self performSelectorOnCommonBackgroundThread:@selector(handleRequestInternal:) withObject:request];
    return YES;
#else
		return [self handleRequestInternal:request];
	#endif
}

- (BOOL)handleRequestInternal:(NSObject <AFQueueableRequest> *)request
{
    //NSLog(@"Handing request: %@",request);

#ifdef BACKGROUND_HANDLING_ENABLED
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif

    BOOL returnVal;
    if (request && request.state != (requestState) fulfilled)
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
- (void)queueRequestAtFront:(NSObject <AFQueueableRequest> *)requestIn
{
    [requestIn addObserver:self];
    [queue insertObject:requestIn atIndex:0];
    [self startWaitingRequests];
}

- (void)queueRequestAtBack:(NSObject <AFQueueableRequest> *)requestIn;
{
    [requestIn addObserver:self];
    [queue addObject:requestIn];
    [self startWaitingRequests];
}

- (void)startConnectionMainThreadInternal:(NSObject <AFRequest> *)request
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    urlRequest = [request willSendURLRequest:urlRequest];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    request.connection = connection;
    [connection release];
}

- (void)requestSizePolled:(int)sizeBytes forRequest:(NSObject <AFRequest> *)requestIn
{}

- (void)requestStarted:(NSObject <AFRequest> *)requestIn
{}

- (void)requestProgressUpdated:(float)completion forRequest:(NSObject <AFRequest> *)requestIn
{}

- (void)requestComplete:(NSObject <AFRequest> *)requestIn
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestCancelled:(NSObject <AFRequest> *)requestIn
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestReset:(NSObject <AFRequest> *)requestIn //Same behaviour as cancel (dequeue)
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (void)requestFailed:(NSObject <AFRequest> *)requestIn;
{
    //NSLog(@"%@, %@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd), [[requestIn URL] absoluteString]);

    [requestIn removeObserver:self];
    [queue removeObject:requestIn];
    [activeRequests removeObject:requestIn];
    [self startWaitingRequests];
}

- (NSObject <AFRequest> *)queuedRequestForConnection:(NSURLConnection *)connection
{
    for (NSObject <AFRequest> *testRequest in queue) if (testRequest.connection == connection) return testRequest;
    for (NSObject <AFRequest> *testRequest in activeRequests) if (testRequest.connection == connection) return testRequest;
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

- (BOOL)isRequestActive:(NSObject <AFRequest> *)request
{return [activeRequests containsObject:request];}

// NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSObject <AFRequest> *findRequest = [self queuedRequestForConnection:connection];

    NSString *responseString = [NSString stringWithFormat:@"Couldn't find the request that I received a response to! %@", [[response URL] absoluteString]];
    NSAssert(findRequest != nil, responseString);

    [findRequest willReceiveWithHeaders:[((NSHTTPURLResponse *) response) allHeaderFields] responseCode:[((NSHTTPURLResponse *) response) statusCode]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

    NSObject <AFRequest> *findRequest = [self queuedRequestForConnection:connection];
    if (findRequest) [findRequest received:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

    NSObject <AFRequest> *findRequest;

    //[self setOffline:YES];

    NSAssert(findRequest = [self queuedRequestForConnection:connection], @"Couldn't find the request for connection in %@", [self class]);

    [findRequest didFail:error];

    //[connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));

    NSObject <AFRequest> *findRequest = [[self queuedRequestForConnection:connection] retain];

    //NSAssert(findRequest,@"Couldn't retrieve request for finished connection");

    [findRequest didFinish]; //Tell the object that it finished (so it can do something useful with the data)
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
    for (NSObject <AFQueueableRequest> *request in queue)[request removeObserver:self];
    [queue release];
    [activatedRequests release];
    [super dealloc];
}

@synthesize queue, activeRequests;

@end
