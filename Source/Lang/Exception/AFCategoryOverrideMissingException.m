//
// Created by augmental on 18/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFCategoryOverrideMissingException.h"


@implementation AFCategoryOverrideMissingException

-(id)init
{
    self = [super initWithName:NSStringFromClass([self class]) reason:@"This code should not have been reached because it was intended that a Category would override this method." userInfo:NULL];
    return self;
}

@end