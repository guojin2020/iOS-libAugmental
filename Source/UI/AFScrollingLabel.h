//
// Created by IE on 20/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface AFScrollingLabel : UIView

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) UIFont*   font;
@property (nonatomic, assign) float     fontSize;
@property (nonatomic, assign) float     fadeSize;
@property (nonatomic, readonly) CFTypeRef ctFont;
@property (nonatomic, retain) UIColor* textColor;

@end