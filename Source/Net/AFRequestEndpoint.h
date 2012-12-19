@class AFRequest;

@protocol AFRequestEndpoint

- (void)request:(AFRequest*)request returnedWithData:(id)data;

@end
