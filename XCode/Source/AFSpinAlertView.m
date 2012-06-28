#import "AFSpinAlertView.h"

static BOOL alreadyShowingOne = NO;

@implementation AFSpinAlertView

-(id)initWithTitle:(NSString*)titleIn message:(NSString*)messageIn
{
    if((self = [super init]))
	{
        self.title = titleIn;
		self.message = messageIn;
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return self;
}

-(void)show
{
	//NSAssert(!alreadyShowingOne,@"Already showing one!");
	
	alreadyShowingOne = YES;
	
	[super show];
	[self addSubview:indicator];
	indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 42);
	[indicator startAnimating];
}

/*
-(void)setBounds:(CGRect)rectIn
{
	[super setBounds:rectIn];
	indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height - 42);
}
*/

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
	[indicator stopAnimating];
}

-(void)dismiss
{
	alreadyShowingOne = NO;
	[indicator removeFromSuperview];
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)dealloc
{
	[indicator release];
	[super dealloc];
}


@end
