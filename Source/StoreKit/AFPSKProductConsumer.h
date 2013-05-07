//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

@class AFSKProductFetchResponse;
@class AFSKProductRequest;

@protocol AFPSKProductConsumer

-(void)willSendProductRequest:(AFSKProductRequest*)request;
-(void)didReceiveResponse:(AFSKProductFetchResponse *)result toProductRequest:(AFSKProductRequest*)request;

@property(nonatomic,readonly) NSString* storeKitProductId;

@end