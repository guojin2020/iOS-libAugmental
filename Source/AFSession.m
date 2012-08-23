
#import "AFSessionStates.h"

//#import "AFAppDelegate.h"
#import "AFDownloadRequest.h"
#import "AFRequestQueue.h"
#import "AFSession.h"
#import "AFEnvironment.h"
#import "AFRequestQueue.h"
#import "AFObjectCache.h"
#import "AFImmediateRequest.h"
#import "AFRequest.h"
#import "AFUtil.h"
#import "AFRequestQueueAlertView.h"

@implementation AFSession

static const BOOL threadedMode = NO;
static AFSession* sharedSession = nil;

+(AFSession*)sharedSession
{
	if(!sharedSession)
	{
		sharedSession = [AFSession alloc];
		[sharedSession init];
	}
	return sharedSession;
}

-(id)init
{
	if((self = [super initWithTargetHandler:nil maxConcurrentDownloads:8]))
	{
		cookieStore		= [NSHTTPCookieStorage sharedHTTPCookieStorage];
		[cookieStore setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cookiesUpdated:) name:@"NSHTTPCookieManagerCookiesChangedNotification" object:cookieStore];
		observers		= [[NSMutableSet alloc] init];
		state			= (sessionState)disconnected;
		downloadQueue	= [[AFRequestQueue alloc] initWithTargetHandler:(NSObject<AFRequestHandler>*)self maxConcurrentDownloads:2];
		offline			= NO;
		cache			= [[AFObjectCache alloc] init];
	}
	return self;
}

/**
 *	Make superclass constructor inaccessible.
 */
-(id)initWithTargetHandler:(NSObject<AFRequestHandler>*)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(void)addObserver:(NSObject<AFSessionObserver>*)sessionObserver
{
	[observers addObject:sessionObserver];
}

-(void)removeObserver:(NSObject<AFSessionObserver>*)sessionObserver
{
	[observers removeObject:sessionObserver];
}

-(BOOL)connect
{
	[self setState:(sessionState)connecting];
    [self setState:(sessionState)connected];
    return YES;
}

-(BOOL)handleRequest:(NSObject<AFRequest>*)request
{
	if(!request || request.state==(requestState)fulfilled)
	{
		return NO;
	}
	if(!offline)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

-(BOOL)actionRequest:(NSObject<AFRequest>*)request
{
	[self performSelectorOnMainThread:@selector(startConnectionMainThreadInternal:) withObject:request waitUntilDone:NO modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
	return YES;
}

-(void)startConnectionMainThreadInternal:(NSObject<AFRequest>*)request
{
	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:request.URL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
	urlRequest = [request willSendURLRequest:urlRequest];
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:(NSURLRequest*)urlRequest delegate:self startImmediately:YES];
	request.connection = connection;
	[connection release];
}

-(void)requestFailed:(NSObject<AFRequest>*)requestIn
{
    if(requestIn.attempts<=REQUEST_RETRY_LIMIT)
    {
        //NSLog(@"Retrying %i of %i",requestIn.attempts,REQUEST_RETRY_LIMIT);
        [self startConnectionMainThreadInternal:requestIn];
    }
    else
    {
        //NSLog(@"Session going offline in response to retry limit reached...");
        [self setOffline:YES];
        [super requestFailed:requestIn];
    }
    
    [AFRequestQueueAlertView showAlertForQueue:self];
}

-(void)logOut
{
	[self cancelAllRequests];
	[downloadQueue cancelAllRequests];
	[AFDownloadRequest clearRequestPool];
	
	[self setState:(sessionState)disconnecting];
	[self setState:(sessionState)disconnected];
}

-(void)didLogout:(id)logOutResponseData
{
	[self setState:(sessionState)disconnected];
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
	NSObject<AFRequest>* findRequest = [self queuedRequestForConnection:connection];
	
	NSString* responseString = [NSString stringWithFormat:@"Couldn't find the request that I received a response to! %@",[[response URL] absoluteString]];
	NSAssert(findRequest!=nil,responseString);
	
	[findRequest willReceiveWithHeaders:[((NSHTTPURLResponse*)response) allHeaderFields] responseCode:[((NSHTTPURLResponse*)response) statusCode]];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));
    
	NSObject<AFRequest>* findRequest = [self queuedRequestForConnection:connection];
	if(findRequest) [findRequest received:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));
    
	NSObject<AFRequest>* findRequest;
	
	//[self setOffline:YES];
	
	NSAssert(findRequest = [self queuedRequestForConnection:connection],@"Couldn't find the request for connection in %@",[self class]);
	
	[findRequest didFail:error];
	
	//[connection release];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));
    
	NSObject<AFRequest>* findRequest = [[self queuedRequestForConnection:connection] retain];
	
	//NSAssert(findRequest,@"Couldn't retrieve request for finished connection");
	
	[findRequest didFinish]; //Tell the object that it finished (so it can do something useful with the data)
	[findRequest removeObserver:(NSObject<AFRequestObserver>*)self]; //Stop listening to the request
	[queue removeObject:findRequest]; //Remove the request from the list
	[self startWaitingRequests];

	[findRequest release];
	[connection autorelease];
}

-(NSURLRequest*)connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)redirectResponse
{
    //NSLog(@"%@ %@",connection,NSStringFromSelector(_cmd));
    
	if(redirectResponse)
	{
	}
	return request; //Currently always allowing the redirection, by returning the request value
}

-(NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

-(void)cookiesUpdated:(id)message
{
	//[self dumpAllCookies]; //For debugging if necessary
}

-(void)dumpAllCookies
{
	NSArray* allCookies = [cookieStore cookies];
	NSDictionary* cookieProperties;
	for(NSHTTPCookie* currentCookie in allCookies)
	{
		cookieProperties = [currentCookie properties];
		for(id key in cookieProperties)
		{
		}
	}
}

-(void)setState:(sessionState)newState
{
	if(newState!=state)
	{
		sessionState oldState = state;
		state = newState;
		NSSet* observerSnapshot = [[NSSet alloc] initWithSet:observers];
		for(NSObject<AFSessionObserver>* observer in observerSnapshot)if([observer respondsToSelector:@selector(stateOfSession:changedFrom:to:)])[observer stateOfSession:self changedFrom:oldState to:state];
		[observerSnapshot release];
	}
	//if(state==(sessionState)disconnected || state==(sessionState)rejected) offline = NO;
}

-(void)setOffline:(BOOL)offlineState
{
	[super setOffline:offlineState];
	
	if(offline != offlineState)
	{
		offline = offlineState;
		for(NSObject<AFSessionObserver>* observer in observers) if([observer respondsToSelector:@selector(session:becameOffline:)])[observer session:self becameOffline:offline];
	}
}

-(sessionState)state{return state;}
-(BOOL)offline{return offline;}

-(void)request:(NSObject<AFRequest>*)request returnedWithData:(id)data
{
}

-(void)dealloc
{
	[cache release];
	[username release];
	[password release];
	[downloadQueue release];
	[environment release];
	[observers release];
	[offlineLoginCache release];
	[requestsAwaitingLogin release];
	[loginData release];
	[super dealloc];
}

@synthesize environment, downloadQueue,cache;

@end
