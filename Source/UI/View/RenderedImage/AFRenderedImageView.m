//
// Created by Chris Hatton on 20/04/2013.
//
#import "AFRenderedImageView.h"
#import "AFPImageRenderer.h"
#import "AFRenderedImageCache.h"

@implementation AFRenderedImageView

-(id)initWithRenderer:(id<AFPImageRenderer>)rendererIn
{
	NSAssert(rendererIn,NSInvalidArgumentException);

	self = [super init];
	if(self)
	{
		renderer = rendererIn;
	}
	return self;
}

- (void)setRenderer:(id<AFPImageRenderer>)rendererIn
{
	if(rendererIn!=renderer)
	{
		renderer = rendererIn;

		self.image = NULL;
		[self setNeedsLayout];
	}
}

- (id<AFPImageRenderer>)renderer
{
	return renderer;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	CGSize
		selfSize  = self.frame.size,
		imageSize = self.image ? self.image.size : CGSizeZero;

	// If this view has a non-zero size and the current image size doesn't match
	if( selfSize.width>0 && selfSize.height>0 && !CGSizeEqualToSize(imageSize, selfSize) && renderer)
	{
		self.image = [[AFRenderedImageCache sharedInstance] imageFromRenderer:renderer withSize:selfSize];
	}
}

@end