//
// Created by Chris Hatton on 16/01/2013
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>


@interface AFActivityLabel : UIView
{
	UILabel* label;
	UIActivityIndicatorView* indicator;
	float spacing;
}
@property(nonatomic) float spacing;

- (id)initWithLabel:(UILabel *)aLabel;

+ (id)objectWithLabel:(UILabel *)aLabel;


@end