//
// Created by augmental on 04/03/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+CreateUIImage.h"

@implementation UIView (CreateUIImage)

-(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end