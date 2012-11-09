//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFSKProductRequest.h"
#import "AFPSKProductIdProvider.h"
#import "AFPSKProductConsumer.h"

@implementation AFSKProductRequest
{
    NSString* productId;
    id<AFPSKProductConsumer> productConsumer;
}

-(id)initWithProductId:(NSString *)productIdIn consumer:(id<AFPSKProductConsumer>)productConsumerIn
{
    self = [super init];
    if(self)
    {
        productId = [productIdIn retain];
        productConsumer = [productConsumerIn retain];
    }
    return self;
}

-(void)dealloc
{
    [productId release];
    [productConsumer release];
    [super dealloc];
}

@end