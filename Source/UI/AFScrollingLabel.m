//
// Created by Chris Hatton on 28/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFScrollingLabel.h"

typedef enum AFScrollingLabelMask
{
	AFScrollingLabelMaskNone  = 0,
	AFScrollingLabelMaskStart = 1,
	AFScrollingLabelMaskEnd   = 2,
	AFScrollingLabelMaskBoth  = 3
}
AFScrollingLabelMask;

typedef enum AFScrollingLabelAnimationMode
{
	AFScrollingLabelAnimationModeNone,
	AFScrollingLabelAnimationModeBounce,
	//AFScrollingLabelAnimationModeLoop,    // To be implemented
	//AFScrollingLabelAnimationModeSlide    // To be implemented
}
AFScrollingLabelAnimationMode;

typedef enum AFScrollingLabelAnimationStep
{
	AFScrollingLabelAnimationStepIdle           = 0,
	AFScrollingLabelAnimationStepHoldStart      = 1,
	AFScrollingLabelAnimationStepScrollToEnd    = 2,
	AFScrollingLabelAnimationStepHoldEnd        = 3,
	AFScrollingLabelAnimationStepScrollToStart  = 4
}
AFScrollingLabelAnimationStep;

@interface AFScrollingLabel ()

- (void)nextAnimationStep;
- (void)animateScrollTextLayerToPosition:(float)toX;
- (void)refreshMaskGradient;

@end

@implementation AFScrollingLabel
{
    CATextLayer     *textLayer;
	CAGradientLayer *maskLayer;

    NSTimer *stepTimer;
    float fadeSize;

	CGColorRef
		white,
		black,
		clear;

	AFScrollingLabelMask maskMode;

	NSArray
		*maskColors,
		*maskStops;

	NSArray
		*maskStartColors,
		*maskEndColors,
		*maskBothColors;

	NSMutableArray
		*maskStartStops,
		*maskEndStops,
		*maskBothStops;

	AFScrollingLabelAnimationStep animationStep;
	AFScrollingLabelAnimationMode animationMode;

	float
		readSpeed,          // In points per second
		extraHoldDuration;

	// Variables below are used in refreshMaskGradient
	// This is called very frequently so its variables are allocated here for optimisation

	float
		width,
		height,
		textLayerLeft,
		textLayerRight,
		maskLayerLeft,
		maskLayerRight,
		startFadeSize,
		endFadeSize;
}

- (id)init
{
    self = [super init];
    if (self)
    {
	    textLayer = [[CATextLayer     alloc] init];
	    maskLayer = [[CAGradientLayer alloc] init];

	    textLayer.delegate = self;

	    white = [UIColor whiteColor].CGColor,
	    black = [UIColor blackColor].CGColor,
	    clear = [UIColor clearColor].CGColor;

	    textLayer.foregroundColor = white;
	    textLayer.backgroundColor = clear;

	    CGColorRef
			maskOnColor  = black,
	        maskOffColor = clear;

	    maskStartColors = [[NSArray alloc] initWithObjects:(id)maskOffColor, (id)maskOnColor,  NULL];
	    maskEndColors   = [[NSArray alloc] initWithObjects:(id)maskOnColor,  (id)maskOffColor, NULL];
	    maskBothColors  = [[NSArray alloc] initWithObjects:(id)maskOffColor, (id)maskOnColor,  (id)maskOnColor, (id)maskOffColor, NULL];

	    maskStartStops  = [[NSMutableArray alloc] initWithObjects:@0.0, @0.0, NULL];
	    maskEndStops    = [[NSMutableArray alloc] initWithObjects:@0.0, @0.0, NULL];
	    maskBothStops   = [[NSMutableArray alloc] initWithObjects:@0.0, @0.0, @0.0, @0.0, NULL];

	    maskLayer.startPoint = CGPointMake(0.0, 0.5);
	    maskLayer.endPoint   = CGPointMake(1.0, 0.5);

	    CALayer* layer = self.layer;

	    layer.mask = maskLayer;
	    [layer addSublayer:textLayer];

	    fadeSize = 5.0;

	    animationMode = AFScrollingLabelAnimationModeBounce;
	    animationStep = AFScrollingLabelAnimationStepIdle;
    }

    return self;
}

// Start: CALayerDelegate implementation

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	[self refreshMaskGradient];
	[super drawLayer:layer inContext:ctx];
}

/*
- (void)displayLayer:(CALayer *)layer
{
	[super displayLayer:layer];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
	[super layoutSublayersOfLayer:layer];
}

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
	return [super actionForLayer:layer forKey:event];
}
*/

// End: CALayerDelegate implementation

// Start: CAAnimationDelegate implementation

- (void)animationDidStart:(CAAnimation *)anim
{
    [super animationDidStart:anim];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [super animationDidStop:anim finished:flag];

	[self nextAnimationStep];
}

-(void)nextAnimationStep
{
	switch ( animationMode )
	{
		case AFScrollingLabelAnimationModeNone: break;

		case AFScrollingLabelAnimationModeBounce:
		{
			if ( ++animationStep > AFScrollingLabelAnimationStepScrollToStart ) animationStep = AFScrollingLabelAnimationStepHoldStart;

			switch ( animationStep )
			{
				case AFScrollingLabelAnimationStepIdle: break;

				case AFScrollingLabelAnimationStepHoldStart:
				case AFScrollingLabelAnimationStepHoldEnd:
				{
					float holdDuration = ( width * readSpeed ) + extraHoldDuration;
					stepTimer = [NSTimer timerWithTimeInterval:holdDuration target:self selector:_cmd userInfo:NULL repeats:NO];
				}
			    break;

				case AFScrollingLabelAnimationStepScrollToEnd:
				{
					[self animateScrollTextLayerToPosition: (maskLayer.frame.size.width - textLayer.frame.size.width) ];
				}
			    break;

				case AFScrollingLabelAnimationStepScrollToStart:
				{
					[self animateScrollTextLayerToPosition:0];
				}
			    break;
			}
		}
	    break;
	}
}

-(void)animateScrollTextLayerToPosition:(float)toX
{
	float
		currentX = textLayer.frame.origin.x,
		distance = fabsf( currentX - toX ),
		scrollDuration = distance / readSpeed;

	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x" ];

	[animation setFromValue: [NSNumber numberWithFloat:currentX ]];
	[animation setToValue:   [NSNumber numberWithFloat:toX      ]];
	[animation setDuration:  scrollDuration                      ];

	[textLayer addAnimation:animation forKey:@"scroll"];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	width   = self.frame.size.width;
	height  = self.frame.size.height;

	textLayer.frame   = CGRectMake(0, 0, width, height);
	textLayer.bounds  = textLayer.frame;
	textLayer.wrapped = NO;
	maskLayer.frame   = CGRectMake(0, 0, width, height);
	maskLayer.bounds = maskLayer.frame;

	self.layer.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);

	[self refreshMaskGradient];
}

- (void)refreshMaskGradient
{
	AFScrollingLabelMask mask = AFScrollingLabelMaskNone;

	textLayerLeft  = textLayer.frame.origin.x,
	textLayerRight = textLayerLeft + textLayer.frame.size.width,
	maskLayerLeft  = maskLayer.frame.origin.x,
	maskLayerRight = maskLayerLeft + maskLayer.frame.size.width;

	if ( textLayerLeft  < maskLayerLeft  )
	{
		mask |= AFScrollingLabelMaskStart;
		startFadeSize = fmaxf ( fmaxf ( maskLayerLeft  - textLayerLeft,  fadeSize ), (width / 2) );
	}

	if ( textLayerRight > maskLayerRight )
	{
		mask |= AFScrollingLabelMaskEnd;
		endFadeSize   = fmaxf ( fmaxf ( textLayerRight - maskLayerRight, fadeSize ), (width / 2) );
	}

	switch ( mask )
	{
		case AFScrollingLabelMaskNone: break;

		case AFScrollingLabelMaskStart:
	        maskColors = maskStartColors;
	        maskStops  = maskStartStops;
	        [maskStartStops replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:   ( startFadeSize/width) ]];
	        break;

		case AFScrollingLabelMaskEnd:
	        maskColors = maskEndColors;
	        maskStops  = maskEndStops;
	        [maskStartStops replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat: 1-(   endFadeSize/width) ]];
	        break;

		case AFScrollingLabelMaskBoth:
	        maskColors = maskBothColors;
	        maskStops  = maskBothStops;
	        [maskStartStops replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:   ( startFadeSize/width) ]];
	        [maskStartStops replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat: 1-(   endFadeSize/width) ]];
	        break;
	}

	if ( mask!=AFScrollingLabelMaskNone && animationStep==AFScrollingLabelAnimationStepIdle )
	{
		[self nextAnimationStep];
	}

	maskLayer.colors    = maskColors;
	maskLayer.locations = maskStops;
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

-(float) fontSize { return (float)textLayer.fontSize; }
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

/*
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
*/

- (CGSize)sizeThatFits:(CGSize)size
{
	UIFont *font = self.font;
	CGSize sizeThatFits = [self.text sizeWithFont:font constrainedToSize:size lineBreakMode:0];
	return sizeThatFits;
}

- (void)dealloc
{
	[textLayer release];
	[maskLayer release];
	[super dealloc];
}

@end