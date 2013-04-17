//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

@class AFSKProductFetchResponse;
@class AFSKProductRequest;

@protocol AFPSKProductConsumer

-(void)willSendRequest:(AFSKProductRequest*)request;
-(void)didReceiveResponse:(AFSKProductFetchResponse*)result toRequest:(AFSKProductRequest*)request;

@property(nonatomic,readonly) NSString* storeKitProductId;

@end