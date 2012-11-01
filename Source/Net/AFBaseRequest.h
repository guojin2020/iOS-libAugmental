#import <Foundation/Foundation.h>
#import "AFRequest.h"
#import "AFRequestObserver.h"
#import "AFRequestStates.h"

typedef enum AFRequestEvent
{
    AFRequestEventStarted,
    AFRequestEventProgressUpdated,
    AFRequestEventFinished,
    AFRequestEventCancel,
    AFRequestEventQueued,
    AFRequestEventReset,
    AFRequestEventSizePolled,
    AFRequestEventFailed
}
AFRequestEvent;

@interface AFBaseRequest : NSObject
{
    NSURL               *URL;
    NSURLConnection     *connection;

    AFRequestState      state;
    int                 expectedBytes;
    int                 receivedBytes;

    NSMutableSet        *observers;
    NSUInteger          attempts;

    NSNumberFormatter   *numberFormatter;
    BOOL                requiresLogin;
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

- (void)broadcastToObservers:(AFRequestEvent)event;

@property(nonatomic, readonly) NSUInteger       attempts;
@property(nonatomic, readonly) NSUInteger       receivedBytes;
@property(nonatomic, readonly) int              expectedBytes;
@property(nonatomic, readonly) float            progress;

@end
