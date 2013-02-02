
#import "AFActivityLabel.h"

static NSString* TEXT_KEY_PATH = @"text";

@implementation AFActivityLabel

@synthesize spacing, label;

- (id)init
{
	self = [super init];
	if (self)
	{
		label        = [[UILabel alloc] init];
		indicator    = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.hidesWhenStopped = YES;

		self.isActive = NO;
		self.spacing  = 6;

        [self addSubview:label];
        [self addSubview:indicator];
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
			[label addObserver:self
                    forKeyPath:TEXT_KEY_PATH
                       options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                       context:NULL];

            [indicator startAnimating];
            //[self setNeedsLayout];
		}
		else
		{
			[label removeObserver:self forKeyPath:TEXT_KEY_PATH];
            [indicator stopAnimating];
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
		indicatorSize = self.isActive ? indicator.frame.size : CGSizeZero,
	    size          = CGSizeMake( labelSize.width + self.spacing + indicatorSize.width, fmaxf( labelSize.height, indicatorSize.height ) );

    CGPoint point = self.frame.origin;
    float halfHeight = size.height/2;

    indicator.frame = CGRectMake( 0, halfHeight-(indicatorSize.height/2), indicatorSize.width, indicatorSize.height );

    label.frame     = CGRectMake( indicatorSize.width + spacing, halfHeight-(labelSize.height/2), labelSize.width, labelSize.height );
	self.frame      = CGRectMake( point.x, point.y, size.width, size.height );
}

- (void)setIsActive:(BOOL)isActive
{
	if( isActive != indicator.isAnimating )
	{
		[self setNeedsLayout];
	}
}

- (BOOL)isActive { return indicator.isAnimating; }

- (void)dealloc
{
	[label release];
	[indicator release];
    [super dealloc];
}

@end