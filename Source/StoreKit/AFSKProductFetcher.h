//
// Created by augmental on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface AFSKProductFetcher : NSObject <SKProductsRequestDelegate>
{
    NSMutableSet* bufferedRequests;
    NSMutableSet* activeRequests;

    NSUInteger bufferLockCount;
}
+(AFSKProductFetcher *)sharedInstance;

-(void)lock;
-(void)unlock;

@end