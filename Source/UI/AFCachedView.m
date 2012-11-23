//
// Created by Chris Hatton on 14/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFCachedView.h"


@implementation AFCachedView
{
    UIImage* cacheImage;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        cacheImage = nil;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    cacheImage = nil;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

     if(cacheImage)
     {
         CGContextDrawImage(context, rect, cacheImage.CGImage);
     }
     else
     {
         //[self drawRectInternal:];
         cacheImage = UIGraphicsGetImageFromCurrentImageContext();
     }
}

@end