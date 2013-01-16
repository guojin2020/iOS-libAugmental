//
// Created by augmental on 16/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFSpinnerLabel.h"


@implementation AFSpinnerLabel
{

}

- (id)init
{
    self = [super init];
    if (self)
    {
        label = [[UILabel alloc] init];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];

    if( (newWindow==nil) != (self.window==nil) )
    {
        if (newWindow)
        {
            [label addObserver:self
                    forKeyPath:@"text"
                       options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                       context:NULL];
        }
        else
        {
            [label removeObserver:self forKeyPath:@"text"];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"text"])
    {
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // Font metrics stuff
}


- (void)dealloc
{
    [label release];
    [spinner release];
    [super dealloc];
}


@end