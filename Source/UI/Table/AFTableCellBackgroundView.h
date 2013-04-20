
#import <UIKit/UIKit.h>
#import "AFTableCell.h"
#import "AFPThemeable.h"

#define THEME_KEY_ROUNDING				@"rounding"
#define THEME_KEY_BORDER_WIDTH			@"borderWidth"
#define THEME_KEY_DEFAULT_BG_COLOR		@"bgColor"
#define THEME_KEY_DEFAULT_BORDER_COLOR	@"borderColor"

typedef enum AFTableCellBackgroundViewPosition
{
    AFTableCellBackgroundViewPositionTop    = 1,
    AFTableCellBackgroundViewPositionMiddle = 2,
    AFTableCellBackgroundViewPositionBottom = 3,
    AFTableCellBackgroundViewPositionSingle = 4
}
AFTableCellBackgroundViewPosition;

@interface AFTableCellBackgroundView : UIView <AFPThemeable>
{
    AFTableCell* cell;
    AFTableCellBackgroundViewPosition position;
}

-(id)initWithFrame:(CGRect)frame usefulTableCell:(AFTableCell*)usefulCellIn;

+(UIColor*)defaultBackgroundColor;
+(UIColor*)defaultBorderColor;
+(float)defaultRounding;
+(float)defaultBorderWidth;

@property(nonatomic, readonly) AFTableCell* cell;
@property(nonatomic) AFTableCellBackgroundViewPosition position;

@end
