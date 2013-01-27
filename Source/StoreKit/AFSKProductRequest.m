//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
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
    self = [self init];
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