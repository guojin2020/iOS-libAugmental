
#import <Foundation/Foundation.h>

#import "AFObservable.h"

typedef enum AFRequestState
{
    AFRequestStateIdle      = 0,  // The request is AFRequestStateIdle
    AFRequestStateQueued    = 1,  // The request is due to be AFRequestStateFulfilled (AFRequestEventQueued, waiting initialising etc.)
    AFRequestStateInProcess = 2,  // The request is currently in the process of being AFRequestStateFulfilled.
    AFRequestStateFulfilled = 3,  // The request has been AFRequestStateFulfilled.
    AFRequestStateFailed    = 4   // The request has been AFRequestStateFulfilled.
}
AFRequestState;

extern SEL
    AFRequestEventStarted,
    AFRequestEventProgressUpdated,
    AFRequestEventFinished,
    AFRequestEventCancel,
    AFRequestEventQueued,
    AFRequestEventWillPollSize,
    AFRequestEventDidPollSize,
    AFRequestEventFailed;

@interface AFRequest : AFObservable
{
    NSURL               *URL;
    NSURLConnection     *connection;

    int
        responseCode,
        attempts;

    NSNumberFormatter   *numberFormatter;
    BOOL                requiresLogin;
}

- (id)initWithURL:(NSURL *)URLIn;

- (NSDictionary *)httpHeader;

- (id)initWithURL:(NSURL *)URLIn requiresLogin:(BOOL)requiresLoginIn /* DEPRECATED_ATTRIBUTE */;

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn;

- (void)willReceiveWithHeaders:(NSDictionary *)httpHeaderIn responseCode:(int)responseCode;

- (void)requestWasQueuedAtPosition:(NSUInteger)queuePositionIn;

- (void)received:(NSData *)dataIn;
- (void)didFinish;
- (BOOL)complete;
- (void)didFail:(NSError *)error;
- (void)cancel;

@property(nonatomic, readonly) int          attempts;
@property(nonatomic, readonly) int          receivedBytes;
@property(nonatomic, readonly) int          expectedBytes;
@property(nonatomic, readonly) float        progress;
@property(nonatomic, readonly) int          responseCode;
@property(nonatomic, readwrite, retain) NSError* error;
@property(nonatomic, readonly)  BOOL            requiresLogin;
@property(nonatomic, readonly)  NSURL           *URL;
@property(nonatomic, retain)    NSURLConnection *connection;
@property(nonatomic, readonly)  AFRequestState  state;

- (NSString *)actionDescription;

@end
