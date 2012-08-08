
#import "UICustomDisclosureArrowView.h"

@implementation UICustomDisclosureArrowView

static const CGFloat R = 5.5;
static const CGFloat W = 3.0; // line width

-(id)initWithColor:(UIColor*)colorIn
{
	if((self = [self initWithFrame:CGRectMake(0, 0, R*2+W, R*2)]))
	{
		color = [colorIn retain];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame]))
	{
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

-(void)drawRect:(CGRect)rect
{
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds);
	CGFloat y = CGRectGetMidY(self.bounds);
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R-W, y-R);
	CGContextAddLineToPoint(ctxt, x-W, y);
	CGContextAddLineToPoint(ctxt, x-R-W, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
	CGContextSetStrokeColorWithColor(ctxt, [color CGColor]);
	CGContextStrokePath(ctxt);
}

- (void)dealloc {
    [color release];
    [super dealloc];
}

@end
