@class AFRequest;

@protocol AFRequestObserver

@optional

-(void)requestStarted:             (AFRequest*)requestIn;
-(void)requestProgressUpdated:     (AFRequest*)requestIn;
-(void)requestComplete:            (AFRequest*)requestIn;
-(void)requestCancelled:           (AFRequest*)requestIn;
-(void)requestFailed:              (AFRequest*)requestIn;
-(void)handleRequest:              (AFRequest*)requestIn queuedAt:(NSNumber *)positionIn;
-(void)handleRequestReset:         (AFRequest*)requestIn;
-(void)handleRequestWillPollSize:  (AFRequest*)requestIn;
-(void)handleRequestDidPollSize:   (AFRequest*)requestIn;

@end
