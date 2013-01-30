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

    int childCount = self.subviews.count;
    for (uint i = 0; i<childCount; ++i)
    {
        view = [self.subviews objectAtIndex:i];

        if([view conformsToProtocol:@protocol(AFPConstrainedView)])
        {
            space = [((id<AFPConstrainedView>)view) preferredSize].height;
        }
        else
        {
            space = view.frame.size.height;
        }

        spaceRemaining = layoutHeight - caret;

        if( space>spaceRemaining || (fillsRemainder && i==(childCount-1)) )
        {
            space = spaceRemaining;
        }

        view.frame = CGRectMake( self.edgeInsets.left, caret, self.frame.size.width - ( self.edgeInsets.left + self.edgeInsets.right ), space );

        caret += space;
    }
}


@end