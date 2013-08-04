//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFSKProductFetchResponseSuccess.h"


@implementation AFSKProductFetchResponseSuccess
{
    SKProduct* product;
}

- (id)initWithProduct:(SKProduct *)productIn
{
    self = [self init];
    if(self)
    {
        product = productIn;
    }

    return self;
}

-(SKProduct *)product
{
    return product;
}



@end