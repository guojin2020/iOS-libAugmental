//
// Created by darkmoon on 29/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFConstrainedView.h"


@implementation AFConstrainedView

- (CGSize)preferredSize                         { return _preferredSize;            }
- (void)setPreferredSize:(CGSize)preferredSize  { _preferredSize = _preferredSize;  }
- (CGSize)minimumSize                           { return _minimumSize;              }
- (void)setMinimumSize:(CGSize)minimumSize      { _minimumSize = minimumSize;       }

@end