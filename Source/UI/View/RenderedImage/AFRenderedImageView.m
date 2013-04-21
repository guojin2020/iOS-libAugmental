//
// Created by Chris Hatton on 20/04/2013.
//
#import "AFRenderedImageView.h"
#import "AFPImageRenderer.h"
#import "AFRenderedImageCache.h"

@implementation AFRenderedImageView

-(id)initWithRenderer:(NSObject<AFPImageRenderer>*)rendererIn
{
	NSAssert(rendererIn,NSInvalidArgumentException);

	self = [super init];
	if(self)
	{
		renderer = [rendererIn retain];
	}
	return self;
}

-(void)layoutSubviews
{
	[super layoutSubviews];

	CGSize
		selfSize  = self.frame.size,
		imageSize = self.image ? self.image.size : CGSizeZero;

	if( selfSize.width>0 && selfSize.height>0 && !CGSizeEqualToSize(imageSize, selfSize) )
	{
		self.image = [[AFRenderedImageCache sharedInstance] imageFromRenderer:renderer withSize:selfSize];
	}
}

@end