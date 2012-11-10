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
    id<AFPSKProductConsumer> productConsumer;
}

@synthesize productConsumer;

-(id)initWithConsumer:(id<AFPSKProductConsumer>)productConsumerIn
{
    self = [super init];
    if(self)
    {
        productConsumer = [productConsumerIn retain];
    }
    return self;
}

-(void)dealloc
{
    [productConsumer release];
    [super dealloc];
}

@end