//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFSKProductRequest.h"
#import "AFPSKProductConsumer.h"

@implementation AFSKProductRequest
{
    NSObject<AFPSKProductConsumer>* productConsumer;
}

@synthesize productConsumer;

-(id)initWithConsumer:(NSObject<AFPSKProductConsumer>*)productConsumerIn
{
    self = [self init];
    if(self)
    {
        productConsumer = productConsumerIn;
    }
    return self;
}


@end