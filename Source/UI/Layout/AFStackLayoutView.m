//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFStackLayoutView.h"
#import "AFPConstrainedView.h"


@implementation AFStackLayoutView

-(id)init
{
    self = [super init];
    if(self)
    {
        fillsRemainder = true;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UIView *view;
    float space, spaceRemaining, caret = _edgeInsets.top;

    float layoutHeight = self.frame.size.height - ( _edgeInsets.top + _edgeInsets.bottom );

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

        if( space>spaceRemaining || (fillsRemainder && i==childCount -1) )
        {
            space = spaceRemaining;
        }

        view.frame = CGRectMake(_edgeInsets.left, caret, self.frame.size.width - ( _edgeInsets.left + _edgeInsets.right ), space);

        caret += space;
    }
}


@end