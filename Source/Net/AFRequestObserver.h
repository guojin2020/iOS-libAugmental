@class AFRequest;

@protocol AFRequestObserver

@optional

- (void)requestStarted:(AFRequest*)requestIn;         //Params: AFRequest
- (void)requestProgressUpdated:(AFRequest*)requestIn; //Params: AFRequest
- (void)requestComplete:(AFRequest*)requestIn;        //Params: AFRequest
- (void)requestCancelled:(AFRequest*)requestIn;       //Params: AFRequest
- (void)requestFailed:(AFRequest*)requestIn;          //Params: AFRequest
- (void)handleRequest:(AFRequest*)requestIn queuedAt:(NSNumber *)positionIn;//Params: AFRequest, NSNumber
- (void)handleRequestReset:(AFRequest*)requestIn;     //Params: AFRequest
- (void)handleRequestSizePolled:(AFRequest*)requestIn;//Params: AFRequest

@end
