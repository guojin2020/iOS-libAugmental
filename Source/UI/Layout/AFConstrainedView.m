//
// Created by darkmoon on 29/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFConstrainedView.h"

@implementation AFConstrainedView

- (id)init
{
    self = [super init];
    if (self)
    {
       _minimumSize   = CGSizeZero;
       _preferredSize = CGSizeZero; // CGSizeZero here is heuristic for unspecified (use current size)
       _maximumSize   = CGSizeMake ( CGFLOAT_MAX, CGFLOAT_MAX );
    }

    return self;
}


- (CGSize)minimumSize                           { return _minimumSize;              }
- (void)setMinimumSize:(CGSize)minimumSize      { _minimumSize = minimumSize;       }

- (CGSize)maximumSize                           { return _maximumSize;              }
- (void)setMaximumSize:(CGSize)maximumSize      { _maximumSize = maximumSize;       }

- (CGSize)preferredSize
{
    CGSize preferredSize = CGSizeEqualToSize ( _preferredSize, CGSizeZero ) ? self.frame.size : _preferredSize;

    preferredSize.width  = fminf ( preferredSize.width,  _maximumSize.width  );
    preferredSize.width  = fmaxf ( preferredSize.width,  _minimumSize.width  );

    preferredSize.height = fminf ( preferredSize.height, _maximumSize.height );
    preferredSize.height = fmaxf ( preferredSize.height, _minimumSize.height );

    return preferredSize;
}

- (void)setPreferredSize:(CGSize)preferredSize  { _preferredSize = preferredSize;   }

@end