//
// Created by augmental on 28/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFOrientationRespectfulNavigationController.h"


@implementation AFOrientationRespectfulNavigationController

-(BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end