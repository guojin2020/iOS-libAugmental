//
// Created by darkmoon on 29/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
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
    float space, spaceRemaining, caret = 0;

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

        spaceRemaining = self.frame.size.height - caret;

        if( space>spaceRemaining || (fillsRemainder && i==childCount -1) )
        {
            space = spaceRemaining;
        }

        view.frame = CGRectMake(0, caret, self.frame.size.width, space);

        caret += space;
    }
}


@end