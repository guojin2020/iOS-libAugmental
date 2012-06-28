
@protocol AFRequest;

@protocol AFRequestEndpoint

-(void)request:(NSObject<AFRequest>*)request returnedWithData:(id)data;

@end
