
#import <Foundation/Foundation.h>
#import "AFRequest.h"
#import "AFRequestObserver.h"
#import "AFRequestStates.h"

typedef enum requestEvent {started,progressUpdated,finished,cancel,queued,reset,sizePolled,failed} requestEvent;

@interface AFBaseRequest : NSObject
{
	NSURL* URL;
	NSURLConnection* connection;
	requestState state;
	int expectedBytes;
	int receivedBytes;
	NSMutableSet* observers;
	NSNumberFormatter* numberFormatter;
	
	BOOL requiresLogin;

    int attempts;
}

-(id)initWithURL:(NSURL*)URLIn;
-(id)initWithURL:(NSURL*)URLIn requiresLogin:(BOOL)requiresLoginIn;
-(NSMutableURLRequest*)willSendURLRequest:(NSMutableURLRequest*)requestIn;
-(void)willReceiveWithHeaders:(NSDictionary*)headers responseCode:(int)responseCode;
-(void)received:(NSData*)dataIn;
-(void)didFinish;
-(void)didFail:(NSError*)error;
-(void)cancel;

-(void)setExpectedBytesFromHeader:(NSDictionary*)header isCritical:(BOOL)critical;

-(void)addObserver:(NSObject<AFRequestObserver>*)newObserver;
-(void)removeObserver:(NSObject<AFRequestObserver>*)newObserver;
-(void)broadcastToObservers:(requestEvent)event;

@property (nonatomic, readonly) int attempts;
@property (nonatomic, retain) NSURL* URL;
@property (nonatomic, retain) NSURLConnection* connection;
@property (nonatomic) requestState state;
@property (nonatomic, readonly) int receivedBytes;
@property (nonatomic, readonly) int expectedBytes;
@property (nonatomic, readonly) float progress;

@end
