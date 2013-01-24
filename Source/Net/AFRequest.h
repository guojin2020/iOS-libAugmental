
#import <Foundation/Foundation.h>

#import "AFObservable.h"

#import "AFRequestStates.h"

extern SEL
    AFRequestEventStarted,
    AFRequestEventProgressUpdated,
    AFRequestEventFinished,
    AFRequestEventCancel,
    AFRequestEventQueued,
    AFRequestEventReset,
    AFRequestEventWillPollSize,
    AFRequestEventDidPollSize,
    AFRequestEventFailed;

@interface AFRequest : AFObservable
{
    NSURL               *URL;
    NSURLConnection     *connection;
    
    AFRequestState      state;
    int                 expectedBytes;
    int                 receivedBytes;

    int                 responseCode;
    int                 attempts;

    NSNumberFormatter   *numberFormatter;
    BOOL                requiresLogin;
}

- (id)initWithURL:(NSURL *)URLIn;
- (id)initWithURL:(NSURL *)URLIn requiresLogin:(BOOL)requiresLoginIn;

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn;

- (bool)isSuccessHTTPResponse;

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCode;
- (void)received:(NSData *)dataIn;
- (void)didFinish;
- (BOOL)complete;
- (void)didFail:(NSError *)error;
- (void)cancel;
- (void)setExpectedBytesFromHeader:(NSDictionary *)header isCritical:(BOOL)critical;

@property(nonatomic, readonly) int          attempts;
@property(nonatomic, readonly) int          receivedBytes;
@property(nonatomic, readonly) int          expectedBytes;
@property(nonatomic, readonly) float        progress;
@property(nonatomic, readonly) int          responseCode;

- (NSString *)actionDescription;

@property(nonatomic, readonly)  BOOL            requiresLogin;
@property(nonatomic, readonly)  NSURL           *URL;
@property(nonatomic, retain)    NSURLConnection *connection;
@property(nonatomic, readonly)  AFRequestState  state;


@end
