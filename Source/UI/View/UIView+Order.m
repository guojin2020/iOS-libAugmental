//
// Created by augmental on 27/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "UIView+Order.h"


@implementation UIView (Order)

-(void)bringToFront
{
    [[self superview] bringSubviewToFront:self];
}

-(void)sendToBack
{
    [[self superview] sendSubviewToBack:self];
}

@end