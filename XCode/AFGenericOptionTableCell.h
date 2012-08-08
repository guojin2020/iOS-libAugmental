
#import <Foundation/Foundation.h>
#import "AFTableCell.h"
#import "AFThemeable.h"

#define THEME_KEY_DISCLOSURE_ARROW_COLOR @"disclosureArrowColor"

@interface AFGenericOptionTableCell : AFTableCell <AFThemeable>
{
	UIImage* labelIcon;
	UILabel* searchOptionLabel;
	UIImageView* searchOptionIcon;
	//UINavigationController* navController;
}

-(id)initWithLabelText:(NSString*)labelTextIn labelIcon:(UIImage*)labelIconIn;
+(UIColor*)disclosureArrowColor;

@end
