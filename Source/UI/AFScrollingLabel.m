//
// Created by IE on 20/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "AFScrollingLabel.h"
#import <CoreText/CoreText.h>

@implementation AFScrollingLabel
{
    CATextLayer *textLayer;
    NSTimer *animationTimer;
    float fadeSize;

    CALayer* maskedLayer, *maskingLayer;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        textLayer       = [[CATextLayer alloc] init];
        maskedLayer     = [[CALayer alloc] init];
        maskingLayer    = [[CALayer alloc] init];

        maskingLayer.delegate = self;
    }

    return self;
}

// Start: CALayerDelegate implementation

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    [super drawLayer:layer inContext:ctx];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];

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

// End: CAAnimationDelegate implementation

- (NSString *)text { return textLayer.string; }
- (void)setText:(NSString *)text
{
    textLayer.string = text;
}

- (float)fadeSize { return _fadeSize; }
- (void)setFadeSize:(float)fadeSize1
{
    _fadeSize = fadeSize1;
}

-(float) fontSize                   { return (float)textLayer.fontSize; }
-(void) setFontSize:(float)fontSize { textLayer.fontSize = (CGFloat)fontSize; }

-(UIFont*) font
{
    NSString *fontName = [(NSString *) CTFontCopyPostScriptName(textLayer.font) autorelease];
    return [UIFont fontWithName:textLayer.font size:self.fontSize];
}

-(void) setFont:(UIFont*)font
{
    CGAffineTransform transform;
    textLayer.font = CTFontCreateWithName(font.fontName, font.pointSize, &transform);
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



@end