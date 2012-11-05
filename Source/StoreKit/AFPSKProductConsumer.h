//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class AFSKProductFetchResponse;
@class AFSKProductRequest;

@protocol AFPSKProductConsumer <AFPSKProductIdProvider>

-(void)willSendRequest:(AFSKProductRequest*)request;
-(void)didReceiveResponse:(AFSKProductFetchResponse*)result toRequest:(AFSKProductRequest*)request;

@end