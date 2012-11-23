//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFPSKProductIdProvider.h"

@class AFSKProductFetchResponse;
@class AFSKProductRequest;

@protocol AFPSKProductConsumer <AFPSKProductIdProvider>

-(void)willSendRequest:(AFSKProductRequest*)request;
-(void)didReceiveResponse:(AFSKProductFetchResponse*)result toRequest:(AFSKProductRequest*)request;

@end