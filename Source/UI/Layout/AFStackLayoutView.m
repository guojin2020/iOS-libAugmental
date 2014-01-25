//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFStackLayoutView.h"
#import "AFPConstrainedView.h"

@implementation AFStackLayoutView

-(id)initWithRemainderFill:(BOOL)fillsRemainderIn
{
    self = [self init];
    if(self)
    {
        fillsRemainder = fillsRemainderIn;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *view;
    float space, spaceRemaining, caret = self.edgeInsets.top;

    float layoutHeight = self.frame.size.height - ( self.edgeInsets.top + self.edgeInsets.bottom );

    NSArray* subviewsToAutoLayout = [self subviewsToAutoLayout];

    for (uint i = 0; i<subviewsToAutoLayout.count; ++i)
    {
        view = [subviewsToAutoLayout objectAtIndex:i];

        if([view conformsToProtocol:@protocol(AFPConstrainedView)])
        {
            space = [((id<AFPConstrainedView>)view) preferredSize].height;
        }
        else
        {
            space = view.frame.size.height;
        }

        spaceRemaining = layoutHeight - caret;

        if( space>spaceRemaining || (fillsRemainder && i==(subviewsToAutoLayout.count-1)) )
        {
            space = spaceRemaining;
        }

        view.frame = CGRectMake( self.edgeInsets.left, caret, self.frame.size.width - ( self.edgeInsets.left + self.edgeInsets.right ), space );

        caret += space;
    }
}


@end