//
// Created by IE on 20/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFScrollingLabel.h"
#import <CoreText/CoreText.h>

@implementation AFScrollingLabel
{
    CATextLayer     *textLayer;
	CAGradientLayer *maskLayer;

    NSTimer *animationTimer;
    float fadeSize;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        textLayer = [[CATextLayer     alloc] init];
        maskLayer = [[CAGradientLayer alloc] init];

	    CGColorRef
		    white = [UIColor whiteColor].CGColor,
	        black = [UIColor blackColor].CGColor,
	        clear = [UIColor clearColor].CGColor;

	    NSArray* maskColors = [[NSArray alloc] initWithObjects:(id)black, (id)white, (id)white, (id)black, nil];
	    maskLayer.colors = maskColors;
	    [maskColors release];

	    NSArray* maskColorLocations = [[NSArray alloc] initWithObjects:@0.0, @0.3, @0.7, @1.0, nil];
	    maskLayer.locations = maskColorLocations;
	    [maskColorLocations release];

	    textLayer.foregroundColor = white;
	    textLayer.backgroundColor = clear;

	    CALayer* layer = self.layer;

	    layer.mask = maskLayer;

	    [layer addSublayer:textLayer];

	    self.text = @"Hello";
    }

    return self;
}

// End: CALayerDelegate implementation

// Start: CAAnimationDelegate implementation

- (void)animationDidStart:(CAAnimation *)anim
{
    [super animationDidStart:anim];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [super animationDidStop:anim finished:flag];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	float
		width   = self.frame.size.width,
		height  = self.frame.size.height;

	textLayer.frame   = CGRectMake(0, 0, width, height);
	textLayer.bounds = textLayer.frame;
	textLayer.wrapped = NO;
	maskLayer.frame   = CGRectMake(0, 0, width, height);
	maskLayer.bounds = maskLayer.frame;
	maskLayer.startPoint = CGPointZero;
	maskLayer.endPoint = CGPointMake(maskLayer.frame.size.width, 0);

	self.layer.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
}


// End: CAAnimationDelegate implementation

- (NSString *)text { return textLayer.string; }
- (void)setText:(NSString *)text
{
	textLayer.string = text;
	[self setNeedsLayout];
}

- (float)fadeSize { return fadeSize; }

- (CFTypeRef)ctFont { return textLayer.font; }

- (void)setFadeSize:(float)fadeSizeIn
{
    fadeSize = fadeSizeIn;
	[self setNeedsLayout];
}

-(float) fontSize                   { return (float)textLayer.fontSize; }
-(void) setFontSize:(float)fontSize
{
	textLayer.fontSize = (CGFloat)fontSize;
	[self setNeedsLayout];
}

-(UIFont*) font
{
    NSString *fontName = [(NSString *) CTFontCopyPostScriptName(textLayer.font) autorelease];
    return [UIFont fontWithName:fontName size:self.fontSize];
}

-(void) setFont:(UIFont*)font
{
    CGAffineTransform transform = CGAffineTransformIdentity;
	CFStringRef fontName = (CFStringRef)font.fontName;
	CTFontRef ctFont = CTFontCreateWithName(fontName, self.font.pointSize, &transform);
	textLayer.font = (CFTypeRef)ctFont;
	[self setNeedsLayout];
}

-(UIColor*)textColor { return [UIColor colorWithCGColor:textLayer.foregroundColor]; }
-(void) setTextColor:(UIColor*)color
{
	textLayer.foregroundColor = color.CGColor;
	[self setNeedsDisplay];
}

-(void)beginScroll:(BOOL)rightToLeft
{
    float
        viewWidth = self.bounds.size.width,
        textWidth = textLayer.bounds.size.width;

    NSAssert(viewWidth < textWidth, @"We shouldn't be scrolling at all if the text fits normally");

    float endOffset = rightToLeft ? 0 : - (textWidth - viewWidth);

    CGPoint
        endPoint     = CGPointMake(0, endOffset),
        currentPoint = [textLayer position];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    [anim setFromValue:[NSValue valueWithCGPoint:currentPoint]];
    [anim setToValue:[NSValue valueWithCGPoint:endPoint]];
    [anim setDelegate:self];
    [anim setDuration:1.0];

    [textLayer setPosition:endPoint];
    [textLayer addAnimation:anim forKey:@"position"];
}

- (CGSize)sizeThatFits:(CGSize)size
{
	UIFont *font = self.font;
	return [self.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeClip];
}

- (void)dealloc
{
	[textLayer release];
	[maskLayer release];
	[super dealloc];
}


@end