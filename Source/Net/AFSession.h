#import <Foundation/Foundation.h>

#import "AFSessionState.h"
#import "AFSessionObserver.h"
#import "AFRequestQueue.h"
#import "AFRequestEndpoint.h"
#import "AFRequestObserver.h"
#import "AFRequestHandler.h"

@class AFRequest;
@class AFUtil;
@class AFRequestQueue;
@class AFObjectCache;
@class AFEnvironment;

DEPRECATED_ATTRIBUTE
@interface AFSession : AFRequestQueue <AFSessionObserver, AFRequestEndpoint>
{
    NSString            *username;
    NSString            *password;
    NSHTTPCookieStorage *cookieStore;
    NSMutableData       *loginData;

    //NSMutableArray* requests;
    AFRequestQueue *downloadQueue;

    NSMutableDictionary *offlineLoginCache;
    AFSessionState state;
    NSMutableSet *observers;
    NSMutableSet *requestsAwaitingLogin;

    BOOL offline;

    AFEnvironment *environment;

    AFObjectCache *cache;
}

//Initialisers
- (id)initWithTargetHandler:(NSObject <AFRequestHandler> *)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn;

//Public Methods
- (BOOL)connect;

- (void)didLogout:(id)logOutResponseData;

/**
 *	Logs out the current user and reverts the receiving AFSession's customer property to the default guest USER.
 */
- (void)logOut;

//URL Connection Delegate
/*
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)AFSessionStateError;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse;
*/

- (void)addObserver:(NSObject <AFSessionObserver> *)sessionObserver;

- (void)removeObserver:(NSObject <AFSessionObserver> *)sessionObserver;

//-(void)requestAccepted:(AFRequest*)request;

+ (AFSession *)sharedSession;

/**
 * Property signifies the sessions authentication state.
 * Changing this property informs the receiving sessions observers.
 */
@property(nonatomic) AFSessionState state;

/**
 * Property signifies whether this Session can communicate across the internet.
 * Changing this property informs the receiving sessions observers.
 */
@property(nonatomic) BOOL offline;

@property(nonatomic, retain, readonly) AFEnvironment *environment;

@property(nonatomic, retain, readonly) AFRequestQueue *downloadQueue;

@property(nonatomic, retain, readonly) AFObjectCache *cache;

@end


