//
// Created by Chris Hatton on 18/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFCategoryOverrideMissingException.h"


@implementation AFCategoryOverrideMissingException

-(id)init
{
    self = [super initWithName:NSStringFromClass([self class]) reason:@"This code should not have been reached because it was intended that a Category would override this method." userInfo:NULL];
    return self;
}

@end