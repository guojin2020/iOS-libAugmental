#import <Foundation/Foundation.h>
#import "AFRequest.h"
#import "AFRequestObserver.h"
#import "AFRequestStates.h"

typedef enum requestEvent
{
    started,
    progressUpdated,
    finished,
    cancel,
    queued,
    reset,
    sizePolled,
    failed
}
requestEvent;

@interface AFBaseRequest : NSObject
{
    NSUInteger          responseCode;
    int                 expectedBytes;
    int                 receivedBytes;
    NSMutableSet        *observers;
    NSNumberFormatter   *numberFormatter;
    NSURL               *URL;
    BOOL                requiresLogin;
    RequestState        state;
    NSUInteger          attempts;
    NSURLConnection     *connection;
}

- (id)initWithURL:(NSURL *)URLIn;

- (id)initWithURL:(NSURL *)URLIn requiresLogin:(BOOL)requiresLoginIn;

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn;

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCode;

- (void)received:(NSData *)dataIn;

- (void)didFinish;

- (BOOL)complete;

- (void)didFail:(NSError *)error;

- (void)cancel;

- (void)setExpectedBytesFromHeader:(NSDictionary *)header isCritical:(BOOL)critical;

- (void)addObserver:(NSObject <AFRequestObserver> *)newObserver;

- (void)removeObserver:(NSObject <AFRequestObserver> *)newObserver;

- (void)broadcastToObservers:(requestEvent)event;

@property(nonatomic, readonly) NSUInteger       attempts;
@property(nonatomic, readonly) NSUInteger       receivedBytes;
@property(nonatomic, readonly) int              expectedBytes;
@property(nonatomic, readonly) float            progress;

@end
