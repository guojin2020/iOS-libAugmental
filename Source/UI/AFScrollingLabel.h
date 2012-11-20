//
// Created by IE on 20/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

@interface AFScrollingLabel : UIView

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) UIFont*   font;
@property (nonatomic, assign) float     fontSize;
@property (nonatomic, assign) float     fadeSize;

@end