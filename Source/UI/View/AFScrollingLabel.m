//
// Created by Chris Hatton on 28/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#define AF_SCROLLING_LABEL_DEFAULT_READ_SPEED           50
#define AF_SCROLLING_LABEL_SCROLL_SPEED_FACTOR          1
#define AF_SCROLLING_LABEL_DEFAULT_FADE_SIZE            5
#define AF_SCROLLING_LABEL_DEFAULT_EXTRA_HOLD_DURATION  0.5

#import "AFScrollingLabel.h"
#import "AFAssertion.h"

typedef enum AFScrollingLabelMask
{
	AFScrollingLabelMaskNone  = 0,
	AFScrollingLabelMaskStart = 1,
	AFScrollingLabelMaskEnd   = 2,
	AFScrollingLabelMaskBoth  = 3
}
AFScrollingLabelMask;

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

- (void)refreshMaskGradient;
- (void)nextAnimationStep;
- (void)animateScrollTextLayerToPosition:(float)toX;

- (float)endPositionX;

@property (nonatomic, retain) NSTimer* stepTimer;

@end

@implementation AFScrollingLabel
{
	float
		fadeSize,
		readSpeed,          // In points per second
		extraHoldDuration;

    CATextLayer     *textLayer;
	CAGradientLayer *maskLayer;

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

	CGSize textSize;

	AFScrollingLabelTextLayerDelegate *textLayerDelegate;
}

@synthesize stepTimer;

static CGSize cgSizeMax;

+(void)initialize
{
	cgSizeMax = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
}

- (id)initWithAnimationMode:(AFScrollingLabelAnimationMode)animationModeIn
{
    self = [self init];
    if (self)
    {
	    animationMode = animationModeIn;
	    animationStep = AFScrollingLabelAnimationStepIdle;

	    fadeSize          = AF_SCROLLING_LABEL_DEFAULT_FADE_SIZE;
	    readSpeed         = AF_SCROLLING_LABEL_DEFAULT_READ_SPEED;
	    extraHoldDuration = AF_SCROLLING_LABEL_DEFAULT_EXTRA_HOLD_DURATION;

	    textLayer = [[CATextLayer     alloc] init];
	    maskLayer = [[CAGradientLayer alloc] init];

	    textLayer.contentsScale = [[UIScreen mainScreen] scale];

	    self.layer.anchorPoint = CGPointZero;
	    textLayer.anchorPoint  = CGPointZero;
	    maskLayer.anchorPoint  = CGPointZero;

	    textLayer.wrapped = NO;

	    textLayerDelegate = [[AFScrollingLabelTextLayerDelegate alloc] initWithOwner:self];
	    textLayer.delegate  = textLayerDelegate;
	    self.layer.delegate = self;

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

	    maskStartStops  = [[NSMutableArray alloc] initWithObjects:@0.0, @1.0, NULL];
	    maskEndStops    = [[NSMutableArray alloc] initWithObjects:@0.0, @1.0, NULL];
	    maskBothStops   = [[NSMutableArray alloc] initWithObjects:@0.0, @0.0, @1.0, @1.0, NULL];

	    maskLayer.startPoint = CGPointMake(0.0, 0.5);
	    maskLayer.endPoint   = CGPointMake(1.0, 0.5);

	    [self.layer addSublayer:textLayer];
    }

    return self;
}

-(void)nextAnimationStep
{
	switch ( animationMode )
	{
		case AFScrollingLabelAnimationModeNone: break;

		case AFScrollingLabelAnimationModeBounce:
		{
			animationStep = (animationStep == AFScrollingLabelAnimationStepScrollToStart) ?  AFScrollingLabelAnimationStepHoldStart : (animationStep + 1);

			switch ( animationStep )
			{
				case AFScrollingLabelAnimationStepIdle: break;

				case AFScrollingLabelAnimationStepHoldStart:
				case AFScrollingLabelAnimationStepHoldEnd:
				{
					float holdDuration = ( width / readSpeed ) + extraHoldDuration;
					self.stepTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)holdDuration target:self selector:_cmd userInfo:nil repeats:NO];
				}
			    break;

				case AFScrollingLabelAnimationStepScrollToEnd:
				{
					[self animateScrollTextLayerToPosition: [self endPositionX] ];
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

	if(self.layer.mask) [self refreshMaskGradient]; //TEMP!
}

-(void)animateScrollTextLayerToPosition:(float)toX
{
	float
		currentX = textLayer.position.x,
		distance = fabsf( currentX - toX ),
		scrollDuration = (distance / readSpeed) / AF_SCROLLING_LABEL_SCROLL_SPEED_FACTOR;

	if ( toX!=currentX )
	{
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position" ];

		[animation setFromValue: [NSValue valueWithCGPoint:CGPointMake(currentX, 0)]];

		textLayer.position = CGPointMake(toX, 0);

		[animation setToValue:   [NSValue valueWithCGPoint:CGPointMake(toX,      0)]];
		[animation setDuration:  scrollDuration                      ];
		[animation setDelegate:  textLayerDelegate                   ];

		[textLayer addAnimation:animation forKey:@"scroll"];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

	width   = self.frame.size.width;
	height  = self.frame.size.height;

	self.layer.bounds = self.bounds;

	textSize = [self sizeThatFits:cgSizeMax];

	textLayer.bounds = CGRectMake( 0, 0, textSize.width, textSize.height );

	switch (animationStep)
	{
		case AFScrollingLabelAnimationStepIdle:
		case AFScrollingLabelAnimationStepHoldStart:
		case AFScrollingLabelAnimationStepScrollToStart:
		{
			textLayer.position = CGPointZero;
		}
	        break;

		case AFScrollingLabelAnimationStepScrollToEnd:
		case AFScrollingLabelAnimationStepHoldEnd:
		{
			textLayer.position = CGPointMake([self endPositionX], 0);
		}
	        break;
	}

	if(textSize.width > width)
	{
		maskLayer.bounds = CGRectMake(0, 0, width, height);
		self.layer.mask  = maskLayer;

		if (self.layer.mask) [self refreshMaskGradient];

		if ( animationStep==AFScrollingLabelAnimationStepIdle )
		{
			[self nextAnimationStep];
		}
	}
	else
	{
		self.layer.mask = NULL;
	}

	[CATransaction commit];
}

-(float)endPositionX
{
	return fminf ( self.frame.size.width - textSize.width, 0 );
}


- (void) drawLayer:(CALayer*) layer inContext:(CGContextRef) ctx
{
	if(self.layer.mask) [self refreshMaskGradient];
	[super drawLayer:layer inContext:ctx];
}

- (void)refreshMaskGradient
{
    AFAssertMainThread();

	NSAssert(self.layer.mask, @"Inconsistency: %@ was called but mask is not currently enabled", NSStringFromSelector(_cmd));

	AFScrollingLabelMask mask = AFScrollingLabelMaskNone;

	textLayerLeft  = textLayer.position.x,
	textLayerRight = textLayerLeft + textLayer.bounds.size.width,

	maskLayerLeft  = maskLayer.position.x,
	maskLayerRight = maskLayerLeft + maskLayer.bounds.size.width;

	if ( textLayerLeft  < maskLayerLeft  )
	{
		mask |= AFScrollingLabelMaskStart;
		startFadeSize = fminf ( fminf ( maskLayerLeft  - textLayerLeft,  fadeSize ), (width / 2) );
	}

	if ( textLayerRight > maskLayerRight )
	{
		mask |= AFScrollingLabelMaskEnd;
		endFadeSize   = fminf ( fminf ( textLayerRight - maskLayerRight, fadeSize ), (width / 2) );
	}

	switch ( mask )
	{
		case AFScrollingLabelMaskNone: break;

		case AFScrollingLabelMaskStart:
		{
	        maskColors = maskStartColors;
	        maskStops  = maskStartStops;
	        [maskStartStops replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:   ( startFadeSize/width) ]];
		}
	    break;

		case AFScrollingLabelMaskEnd:
		{
	        maskColors = maskEndColors;
	        maskStops  = maskEndStops;
	        [maskEndStops   replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat: 1-(   endFadeSize/width) ]];
		}
	    break;

		case AFScrollingLabelMaskBoth:
		{
	        maskColors = maskBothColors;
	        maskStops  = maskBothStops;
	        [maskBothStops replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:   ( startFadeSize/width) ]];
	        [maskBothStops replaceObjectAtIndex:2 withObject:[NSNumber numberWithFloat: 1-(   endFadeSize/width) ]];
		}
	    break;
	}

	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

	maskLayer.colors    = maskColors;
	maskLayer.locations = maskStops;

	[CATransaction commit];
}

- (NSString *)text { return textLayer.string; }
- (void)setText:(NSString *)text
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	textLayer.string = text;
	[CATransaction commit];

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
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	textLayer.fontSize = (CGFloat)fontSize;
	[CATransaction commit];

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
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	textLayer.foregroundColor = color.CGColor;
	[CATransaction commit];

	[self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)constraintSize
{
	CGSize fitSize = [self.text sizeWithFont:self.font];
	if( fitSize.width > constraintSize.width ) fitSize = CGSizeMake(constraintSize.width, fitSize.height); // Only hacking it like this because sizeWithFont: above doesn't respect NSLineBreakByClipping
	return fitSize;
}

- (void)dealloc
{
	[textLayer release];
	[maskLayer release];
	[textLayerDelegate release];
    [stepTimer release];
    [maskStartColors release];
    [maskEndColors release];
    [maskBothColors release];
    [maskStartStops release];
    [maskEndStops release];
    [maskBothStops release];
    [super dealloc];
}

@end

@interface AFScrollingLabelTextLayerDelegate ()

@end

@implementation AFScrollingLabelTextLayerDelegate

-(id)initWithOwner:(AFScrollingLabel*)ownerIn
{
	self = [self init];
	if(self)
	{
		owner = [ownerIn retain];
	}
	return self;
}

// CALayerDelegate implementation

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	NSLog(@"Test");
}

// CAAnimationDelegate implementation

- (void)animationDidStart:(CAAnimation *)anim
{
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
	[owner nextAnimationStep];
}

- (void)dealloc
{
	[owner release];
	[super dealloc];
}

@end