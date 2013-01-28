//
// Created by augmental on 27/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFLandscapeMPMoviePlayerViewController.h"


@implementation AFLandscapeMPMoviePlayerViewController

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end