
#import <Foundation/Foundation.h>
#import "AFQueueableRequest.h"
#import "AFRequestObserver.h"
#import "AFRequestHandler.h"

//#define THREADED_REQUEST_HANDLER_ENABLED
#define BACKGROUND_HANDLING_ENABLED

#define REQUEST_RETRY_LIMIT 3

@interface AFRequestQueue : NSObject <AFRequestObserver, AFRequestHandler>
{
	NSMutableArray* queue;
	NSMutableSet* activeRequests;
	NSMutableSet* activatedRequests;
	int queuePosition;
	NSObject<AFRequestHandler>* targetHandler;
	int maxConcurrentDownloads;
	
	BOOL keepProcessing;
	
	#ifdef THREADED_REQUEST_HANDLER_ENABLED
	NSCondition* requestThreadCondition;
	NSThread* requestThread;
	#endif
}

-(void)cancelAllRequests;
-(id)initWithTargetHandler:(NSObject<AFRequestHandler>*)targetHandlerIn maxConcurrentDownloads:(int)maxConcurrentDownloadsIn;
-(void)queueRequestAtFront:(NSObject<AFQueueableRequest>*)requestIn;
-(void)queueRequestAtBack:(NSObject<AFQueueableRequest>*)requestIn;

-(BOOL)handleRequest:(NSObject<AFRequest>*)request;

-(NSObject<AFRequest>*)queuedRequestForConnection:(NSURLConnection*)connection;

-(void)setOffline:(BOOL)offlineState;

-(void)startWaitingRequests;

-(BOOL)isRequestActive:(NSObject<AFRequest>*)request;

@property (nonatomic, readonly) NSArray* queue;
@property (nonatomic, readonly) NSSet* activeRequests;

@end
