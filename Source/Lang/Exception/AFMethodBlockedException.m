//
// Created by augmental on 18/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFMethodBlockedException.h"


@implementation AFMethodBlockedException

-(id)init
{
    self = [super initWithName:NSStringFromClass([self class]) reason:@"This inherited method is not appropriate for use in this subclass and has been blocked." userInfo:NULL];
    return self;
}

@end