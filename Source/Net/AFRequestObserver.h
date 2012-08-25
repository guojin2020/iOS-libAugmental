@protocol AFRequest;

@protocol AFRequestObserver

@optional
- (void)requestStarted:(NSObject <AFRequest> *)requestIn;

- (void)requestProgressUpdated:(float)completion forRequest:(NSObject <AFRequest> *)requestIn;

- (void)requestComplete:(NSObject <AFRequest> *)requestIn;

- (void)requestCancelled:(NSObject <AFRequest> *)requestIn;

- (void)requestSizePolled:(int)sizeBytes forRequest:(NSObject <AFRequest> *)requestIn;

- (void)requestReset:(NSObject <AFRequest> *)requestIn;

- (void)requestFailed:(NSObject <AFRequest> *)requestIn;

@end
