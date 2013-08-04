#import "AFSpinAlertView.h"

static BOOL alreadyShowingOne = NO;

@implementation AFSpinAlertView

- (id)initWithTitle:(NSString *)titleIn message:(NSString *)messageIn
{
    if ((self = [self init]))
    {
        self.title   = titleIn;
        self.message = messageIn;
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return self;
}

- (void)show
{
    alreadyShowingOne = YES;

    [super show];
    [self addSubview:indicator];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 42);
    [indicator startAnimating];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    [indicator stopAnimating];
}

- (void)dismiss
{
    alreadyShowingOne = NO;
    [indicator removeFromSuperview];
    [self dismissWithClickedButtonIndex:0 animated:YES];
}



@end
