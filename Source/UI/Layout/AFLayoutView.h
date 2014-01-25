//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>

@interface AFLayoutView : UIView

@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) UIView* backgroundView;
@property (nonatomic, readonly) NSSet* subviewsExcludedFromLayout;

-(void)setSubview:(UIView*)view excludedFromLayout:(BOOL)excluded;

- (NSArray *)subviewsToAutoLayout;

@end