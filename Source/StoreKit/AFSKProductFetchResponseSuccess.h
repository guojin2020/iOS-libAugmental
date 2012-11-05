//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AFSKProductFetchResponse.h"

@interface AFSKProductFetchResponseSuccess : AFSKProductFetchResponse

-(id)initWithProduct:(SKProduct *)product;

@property (nonatomic, readonly) SKProduct* product;

@end