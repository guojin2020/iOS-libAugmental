//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "AFSKProductFetchResponse.h"

@interface AFSKProductFetchResponseSuccess : AFSKProductFetchResponse

-(id)initWithProduct:(SKProduct *)product;

@property (nonatomic, readonly) SKProduct* product;

@end