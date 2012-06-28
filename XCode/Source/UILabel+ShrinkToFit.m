
#import "UILabel+ShrinkToFit.h"

@implementation UILabel (ShrinkToFit)

+(UILabel*)newLabelShrunkToFit:(NSString*)string withFont:(UIFont*)font
{
	CGSize textSize = [string sizeWithFont:font];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,textSize.width,textSize.height)];
	label.text = string;
	return label;
}

@end
