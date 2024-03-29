//
// Created by Chris Hatton on 03/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol AFPSKProductConsumer;
@class AFSKProductRequest;

@interface AFSKProductFetcher : NSObject <SKProductsRequestDelegate>
{
    SKProductsRequest *storeKitRequest;

    NSMutableSet* bufferedRequests;
    NSMutableSet* activeRequests;

    NSUInteger bufferLockCount;
}

+(AFSKProductFetcher *)sharedInstance;

-(void)lock;
-(void)unlock;

- (AFSKProductRequest*)requestProductForConsumer:(NSObject<AFPSKProductConsumer>*)consumer;

@end