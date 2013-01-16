//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFConstrainedView.h"

@implementation AFConstrainedView

- (id)init
{
    self = [super init];
    if (self)
    {
       minimumSize   = CGSizeZero;
       preferredSize = CGSizeZero; // CGSizeZero here is heuristic for unspecified (use current size)
       maximumSize   = CGSizeMake ( CGFLOAT_MAX, CGFLOAT_MAX );
    }
    return self;
}

- (CGSize)minimumSize { return minimumSize; }
- (void)setMinimumSize:(CGSize)minimumSizeIn { minimumSize = minimumSizeIn; }

- (CGSize)maximumSize { return maximumSize; }
- (void)setMaximumSize:(CGSize)maximumSizeIn { maximumSize = maximumSizeIn; }

- (CGSize)preferredSize
{
    CGSize size = CGSizeEqualToSize (preferredSize, CGSizeZero ) ? self.frame.size : preferredSize;

    size.width  = fminf ( size.width,  maximumSize.width  );
    size.width  = fmaxf ( size.width,  minimumSize.width  );

    size.height = fminf ( size.height, maximumSize.height );
    size.height = fmaxf ( size.height, minimumSize.height );

    return size;
}

- (void)setPreferredSize:(CGSize)preferredSizeIn { preferredSize = preferredSizeIn;   }

@end