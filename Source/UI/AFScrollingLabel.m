//
// Created by Chris Hatton on 28/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#define AF_SCROLLING_LABEL_DEFAULT_READ_SPEED           50
#define AF_SCROLLING_LABEL_SCROLL_SPEED_FACTOR          0.25
#define AF_SCROLLING_LABEL_DEFAULT_FADE_SIZE            5
#define AF_SCROLLING_LABEL_DEFAULT_EXTRA_HOLD_DURATION  0

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
		*maskNoneColors,
		*maskStartColors,
		*maskEndColors,
		*maskBothColors;

	NSMutableArray
		*maskNoneStops,
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

	AFScrollingLabelTextLayerDelegate *textLayerDelegate;
}

@synthesize stepTimer;

static CGSize cgSizeMax;

+(void)initialize
{
	cgSizeMax = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
}

- (id)init
{
    self = [super init];
    if (self)
    {
	    fadeSize          = AF_SCROLLING_LABEL_DEFAULT_FADE_SIZE;
	    readSpeed         = AF_SCROLLING_LABEL_DEFAULT_READ_SPEED;
	    extraHoldDuration = AF_SCROLLING_LABEL_DEFAULT_EXTRA_HOLD_DURATION;

	    textLayer = [[CATextLayer     alloc] init];
	    maskLayer = [[CAGradientLayer alloc] init];

	    textLayerDelegate = [[AFScrollingLabelTextLayerDelegate alloc] init];
	    textLayer.delegate = textLayerDelegate;

	    white = [UIColor whiteColor].CGColor,
	    black = [UIColor blackColor].CGColor,
	    clear = [UIColor clearColor].CGColor;

	    textLayer.foregroundColor = white;
	    textLayer.backgroundColor = clear;

	    CGColorRef
			maskOnColor  = black,
	        maskOffColor = clear;

	    maskNoneColors  = [[NSArray alloc] initWithObjects:(id)maskOnColor,  (id)maskOnColor,  NULL];
	    maskStartColors = [[NSArray alloc] initWithObjects:(id)maskOffColor, (id)maskOnColor,  NULL];
	    maskEndColors   = [[NSArray alloc] initWithObjects:(id)maskOnColor,  (id)maskOffColor, NULL];
	    maskBothColors  = [[NSArray alloc] initWithObjects:(id)maskOffColor, (id)maskOnColor,  (id)maskOnColor, (id)maskOffColor, NULL];

	    maskNoneStops   = [[NSMutableArray alloc] initWithObjects:@0.0, @1.0, NULL];
	    maskStartStops  = [[NSMutableArray alloc] initWithObjects:@0.0, @1.0, NULL];
	    maskEndStops    = [[NSMutableArray alloc] initWithObjects:@0.0, @1.0, NULL];
	    maskBothStops   = [[NSMutableArray alloc] initWithObjects:@0.0, @0.0, @1.0, @1.0, NULL];

	    maskLayer.startPoint = CGPointMake(0.0, 0.5);
	    maskLayer.endPoint   = CGPointMake(1.0, 0.5);

	    CALayer* layer = self.layer;

	    layer.mask = maskLayer;
	    [layer addSublayer:textLayer];

	    animationMode = AFScrollingLabelAnimationModeBounce;
	    animationStep = AFScrollingLabelAnimationStepIdle;
    }

    return self;
}

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
			if ( ++animationStep > AFScrollingLabelAnimationStepScrollToStart )
			{
				animationStep = AFScrollingLabelAnimationStepHoldStart;
			}

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
		scrollDuration = (distance / readSpeed) / AF_SCROLLING_LABEL_SCROLL_SPEED_FACTOR;

	if ( toX!=currentX )
	{
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x" ];

		[animation setFromValue: [NSNumber numberWithFloat:currentX ]];
		[animation setToValue:   [NSNumber numberWithFloat:toX      ]];
		[animation setDuration:  scrollDuration                      ];

		[textLayer addAnimation:animation forKey:@"scroll"];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	width   = self.frame.size.width;
	height  = self.frame.size.height;

	CGSize textSize   = [self sizeThatFits:cgSizeMax];
	textLayer.frame   = CGRectMake(0, 0, textSize.width, textSize.height);
	textLayer.bounds  = textLayer.frame;
	textLayer.wrapped = NO;
	maskLayer.frame   = CGRectMake(0, 0, width, height);
	maskLayer.bounds  = maskLayer.frame;

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
		startFadeSize = fminf ( fminf ( maskLayerLeft  - textLayerLeft,  fadeSize ), (width / 2) );
	}

	if ( textLayerRight > maskLayerRight )
	{
		mask |= AFScrollingLabelMaskEnd;
		endFadeSize   = fminf ( fminf ( textLayerRight - maskLayerRight, fadeSize ), (width / 2) );
	}

	switch ( mask )
	{
		case AFScrollingLabelMaskNone:
		{
	        maskColors = maskNoneColors;
			maskStops  = maskNoneStops;
		}
	    break;

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

- (CGSize)sizeThatFits:(CGSize)constraintSize
{
	CGSize textSize = [self.text sizeWithFont:self.font];
	if( textSize.width > constraintSize.width ) textSize = CGSizeMake(constraintSize.width, textSize.height); // Only hacking it like this because sizeWithFont: above doesn't respect NSLineBreakByClipping
	return textSize;
}

- (void)dealloc
{
	[textLayer release];
	[maskLayer release];
	[textLayerDelegate release];
	[super dealloc];
}

@end


@implementation AFScrollingLabelTextLayerDelegate

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	NSLog(@"Test");
}

@end