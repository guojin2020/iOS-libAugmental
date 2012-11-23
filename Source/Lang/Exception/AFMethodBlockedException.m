//
// Created by Chris Hatton on 18/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFMethodBlockedException.h"


@implementation AFMethodBlockedException

-(id)init
{
    self = [super initWithName:NSStringFromClass([self class]) reason:@"This inherited method is not appropriate for use in this subclass and has been blocked." userInfo:NULL];
    return self;
}

@end