
#import "AFSessionState.h"
#import "AFObservable.h"
#import "AFDownloadRequest.h"
#import "AFRequestQueue.h"
#import "AFSession.h"
#import "AFEnvironment.h"
#import "AFObjectCache.h"
#import "AFRequestQueueAlertView.h"
#import "AFPerformSelectorOperation.h"
#import "AFDownloadRequestCache.h"
#import "AFDispatch.h"

@implementation AFSession

static const BOOL threadedMode = NO;
static AFSession *sharedSession = nil;

+ (AFSession *)sharedSession
{
    return sharedSession ?: (sharedSession = [[AFSession alloc] init]);
}

- (id)init
{
    self = [super initWithTargetHandler:nil maxConcurrentDownloads:4];
    if (self)
    {
        cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookieStore setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cookiesUpdated:) name:@"NSHTTPCookieManagerCookiesChangedNotification" object:cookieStore];
        observers     = [[NSMutableSet alloc] init];
        state         = (AFSessionState) AFSessionStateDisconnected;
        downloadQueue = [[AFRequestQueue alloc] initWithTargetHandler:self maxConcurrentDownloads:2];
        offline       = NO;
        cache         = [[AFObjectCache alloc] init];
    }
    return self;
}

/**
 *	Make superclass constructor inaccessible.
 */
- (id)initWithTargetHandler:(NSObject <AFRequestHandler> *)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)addObserver:(NSObject <AFSessionObserver> *)sessionObserver
{
    [observers addObject:sessionObserver];
}

- (void)removeObserver:(NSObject <AFSessionObserver> *)sessionObserver
{
    [observers removeObject:sessionObserver];
}

- (BOOL)connect
{
    [self setState:(AFSessionState) AFSessionStateConnecting];
    [self setState:(AFSessionState) AFSessionStateConnected];
    return YES;
}

- (BOOL)handleRequest:(AFRequest*)request
{
    if( !request || request.state == AFRequestStateFulfilled )
    {
        return NO;
    }
    else if (!offline)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)actionRequest:(AFRequest*)request
{
	dispatch_block_t block = ^
	{
		[self startConnectionInternal:request];
	};

	AFBeginBackgroundDispatch( block );

    return YES;
}

- (void)requestFailed:(AFRequest*)requestIn withError:(NSError*)error;
{
    if (requestIn.attempts <= REQUEST_RETRY_LIMIT)
    {
        //AFLog(@"Retrying %i of %i",requestIn.attempts,REQUEST_RETRY_LIMIT);
	    [self startConnectionInternal:requestIn];
    }
    else
    {
        //AFLog(@"Session going offline in response to retry limit reached...");
        [self setOffline:YES];
        [super requestFailed:requestIn withError:error];
    }

    [AFRequestQueueAlertView showAlertForQueue:self];
}

- (void)logOut
{
    [self cancelAllRequests];
    [downloadQueue cancelAllRequests];

    [[AFDownloadRequestCache defaultCache] clear];

    [self setState:(AFSessionState) AFSessionStateDisconnecting];
    [self setState:(AFSessionState) AFSessionStateDisconnected];
}

- (void)didLogout:(id)logOutResponseData
{
    [self setState:(AFSessionState) AFSessionStateDisconnected];
}

- (void)cookiesUpdated:(id)message
{
    //[self dumpAllCookies]; //For debugging if necessary
}

- (void)dumpAllCookies
{
	/*
    NSArray           *allCookies = [cookieStore cookies];
    NSDictionary      *cookieProperties;
    for (NSHTTPCookie *currentCookie in allCookies)
    {
        cookieProperties = [currentCookie properties];
    }
    */
}

- (void)setState:(AFSessionState)newState
{
    if (newState != state)
    {
        AFSessionState oldState = state;
        state = newState;
        NSSet                             *observerSnapshot = [[NSSet alloc] initWithSet:observers];
        for (NSObject <AFSessionObserver> *observer in observerSnapshot)if ([observer respondsToSelector:@selector(stateOfSession:changedFrom:to:)])[observer stateOfSession:self changedFrom:oldState to:state];
    }
    //if(state==(AFSessionState)AFSessionStateDisconnected || state==(AFSessionState)AFSessionStateRejected) offline = NO;
}

- (void)setOffline:(BOOL)offlineState
{
    [super setOffline:offlineState];

    if (offline != offlineState)
    {
        offline = offlineState;
        for (NSObject <AFSessionObserver> *observer in observers) if ([observer respondsToSelector:@selector(session:becameOffline:)])[observer session:self becameOffline:offline];
    }
}

- (AFSessionState)state { return state; }

- (BOOL)offline { return offline; }

- (void)request:(AFRequest*)request returnedWithData:(id)data
{
}


@synthesize environment, downloadQueue, cache;

@end
