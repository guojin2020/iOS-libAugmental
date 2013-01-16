//
// Created by Chris Hatton on 16/01/2013
// Contact: christopherhattonuk@gmail.com
//

#import "AFActivityLabel.h"

static NSString* TEXT_KEY_PATH = @"text";

@implementation AFActivityLabel
@synthesize spacing;


- (id)init
{
	self = [super init];
	if (self)
	{
		label = [[UILabel alloc] init];
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		self.spacing = 6f;
	}

	return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
	[super willMoveToWindow:newWindow];

	if((newWindow==nil)!=(self.window==nil))
	{
		if(newWindow)
		{
			[label addObserver:self forKeyPath:TEXT_KEY_PATH options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		}
		else
		{
			[label removeObserver:self forKeyPath:TEXT_KEY_PATH];
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];

	if ([keyPath isEqualToString:TEXT_KEY_PATH]) [self setNeedsLayout];
}


- (void)layoutSubviews
{
	[super layoutSubviews];

	CGSize
		labelSize     = [label sizeThatFits:CGSizeZero],
		indicatorSize = indicator.frame.size,
	    size          = CGSizeMake(labelSize.width+self.spacing+indicatorSize.width, fmaxf(labelSize.height, indicatorSize.height));

	self.frame = CGRectMake(0, 0, <#(CGFloat)width#>, <#(CGFloat)height#>)



}


- (void)dealloc
{
	[label release];
	[indicator release];
	[super dealloc];
}

+ (id)objectWithLabel:(UILabel *)aLabel {
	return [[[AFActivityLabel alloc] initWithLabel:aLabel] autorelease];
}


@end