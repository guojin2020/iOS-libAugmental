
#import <UIKit/UIKit.h>
#import "AFTableCell.h"
#import "AFThemeable.h"

#define THEME_KEY_ROUNDING				@"rounding"
#define THEME_KEY_BORDER_WIDTH			@"borderWidth"
#define THEME_KEY_DEFAULT_BG_COLOR		@"bgColor"
#define THEME_KEY_DEFAULT_BORDER_COLOR	@"borderColor"

typedef enum 
{
    TableCellBackgroundViewPositionTop		= 1,
    TableCellBackgroundViewPositionMiddle	= 2, 
    TableCellBackgroundViewPositionBottom	= 3,
    TableCellBackgroundViewPositionSingle	= 4
}	TableCellBackgroundViewPosition;

@interface AFTableCellBackgroundView : UIView <AFThemeable>
{
    AFTableCell* cell;
    TableCellBackgroundViewPosition position;
}

-(id)initWithFrame:(CGRect)frame usefulTableCell:(AFTableCell*)usefulCellIn;

+(UIColor*)defaultBackgroundColor;
+(UIColor*)defaultBorderColor;
+(float)defaultRounding;
+(float)defaultBorderWidth;

@property(nonatomic, readonly) AFTableCell* cell;
@property(nonatomic) TableCellBackgroundViewPosition position;

@end
