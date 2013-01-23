@class AFRequest;

@protocol AFRequestEndpoint

- (void)request:(AFRequest*)request returnedWithData:(id)data;
- (void)requestFailed:(AFRequest*)request;

@end
