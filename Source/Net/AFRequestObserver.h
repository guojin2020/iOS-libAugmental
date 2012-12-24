@class AFRequest;

@protocol AFRequestObserver

- (void)requestStarted:(AFRequest*)requestIn;

- (void)requestProgressUpdated:(float)completion forRequest:(AFRequest*)requestIn;

- (void)requestComplete:(AFRequest*)requestIn;

- (void)requestCancelled:(AFRequest*)requestIn;

- (void)requestSizePolled:(int)sizeBytes forRequest:(AFRequest*)requestIn;

- (void)requestReset:(AFRequest*)requestIn;

- (void)requestFailed:(AFRequest*)requestIn;

@end
