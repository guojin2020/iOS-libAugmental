//
// Created by augmental on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "AFBaseObject.h"
#import "AFObject.h"

//#import "StoreKit/SKProductsRequest.h"

@interface AFSKProductCache : AFBaseObject <AFObject, SKProductsRequestDelegate>
{
    NSMutableDictionary* idsProducts;
}

@end