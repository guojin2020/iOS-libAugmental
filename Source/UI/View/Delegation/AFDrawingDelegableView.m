//
// Created by Chris Hatton on 25/11/2012
// Contact: christopherhattonuk@gmail.com
//

#import "AFDrawingDelegableView.h"

@implementation AFDrawingDelegableView

@synthesize delegate;

-(void)willMoveToWindow:(UIWindow *)newWindow
{
	[super willMoveToWindow:newWindow];
	[delegate view:self willMoveToWindow:newWindow];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	[delegate layoutSubviewsInView:self];
}

-(void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	[delegate drawRect:rect inView:self];
}


@end