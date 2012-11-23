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
    self = [super init];
    if(self)
    {
        product = [productIn retain];
    }

    return self;
}

-(SKProduct *)product
{
    return product;
}


-(void)dealloc
{
    [product release];
    [super dealloc];
}

@end