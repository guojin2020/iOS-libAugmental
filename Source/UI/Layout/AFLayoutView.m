//
// Created by darkmoon on 29/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "AFLayoutView.h"


@implementation AFLayoutView

-(id)init
{
    self = [super init];
    if(self)
    {
        _edgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (UIEdgeInsets)edgeInsets                      { return _edgeInsets;       }
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets  { _edgeInsets = edgeInsets; }

@end