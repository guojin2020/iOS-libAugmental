#import <Foundation/Foundation.h>

#import "AFRequestObserver.h"
#import "AFRequestHandler.h"

@class AFRequest;

//#define THREADED_REQUEST_HANDLER_ENABLED
#define BACKGROUND_HANDLING_ENABLED

#define REQUEST_RETRY_LIMIT 3

@interface AFRequestQueue : NSObject <AFRequestHandler, AFRequestObserver>

- (void)cancelAllRequests;

- (id)initWithTargetHandler:(NSObject <AFRequestHandler> *)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn;

- (void)queueRequestAtFront:(AFRequest*)requestIn;

- (void)queueRequestAtBack:(AFRequest*)requestIn;

- (BOOL)handleRequest:(AFRequest*)request;

- (AFRequest*)queuedRequestForConnection:(NSURLConnection *)connection;

- (void)setOffline:(BOOL)offlineState;

- (void)startWaitingRequests;

- (BOOL)isRequestActive:(AFRequest*)requestIn;

- (void)startConnectionInternal:(AFRequest*)requestIn;

@property(nonatomic, readonly) NSArray *queue;
@property(nonatomic, readonly) NSSet   *activeRequests;

@end
