//
// Created by IE on 20/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

typedef enum AFScrollingLabelAnimationMode
{
	AFScrollingLabelAnimationModeNone,
	AFScrollingLabelAnimationModeBounce,
	//AFScrollingLabelAnimationModeLoop,    // To be implemented
	//AFScrollingLabelAnimationModeSlide    // To be implemented
}
AFScrollingLabelAnimationMode;

@interface AFScrollingLabel : UIView

- (id)initWithAnimationMode:(AFScrollingLabelAnimationMode)animationModeIn;

- (void) drawLayer:(CALayer*) layer inContext:(CGContextRef) ctx;

@property (nonatomic, strong)   NSString* text;
@property (nonatomic, strong)   UIFont*   font;
@property (nonatomic, assign)   float     fontSize;
@property (nonatomic, assign)   float     fadeSize;
@property (nonatomic, readonly) CFTypeRef ctFont;
@property (nonatomic, strong)   UIColor*  textColor;

@end


@interface AFScrollingLabelTextLayerDelegate : NSObject
{
	AFScrollingLabel* owner;
}

-(id)initWithOwner:(AFScrollingLabel *)owner;

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

-(void)animationDidStart:(CAAnimation *)anim;
-(void)animationDidStop: (CAAnimation *)anim finished:(BOOL)finished;

//@property (nonatomic, readonly) bool isAnimating;

@end