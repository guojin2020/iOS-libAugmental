
#import <Foundation/Foundation.h>
#import "AFCellSelectionDelegate.h"
#import "AFTableCell.h"
#import "AFBlockEditableObject.h"
#import "AFThemeable.h"

#define THEME_KEY_HEADER_COLOR			@"headerColor"
#define THEME_KEY_HEADER_SHADOW_COLOR	@"headerShadowColor"
#define THEME_KEY_HEADER_SHADOW_ENABLED	@"headerShadowEnabled"

@protocol AFTableSectionObserver;
@class AFTable;

/**
 *	Represents a basic section in a table, with a text header and any number of cells.
 */
@interface AFTableSection : AFBlockEditableObject <NSFastEnumeration, AFThemeable>
{
	NSString* title;
	NSMutableArray* children;
	AFTable* parentTable;
}

-(id)initWithTitle:(NSString*)titleIn;
-(AFTableCell*)cellAtIndex:(NSInteger)index;
-(void)addCell:(AFTableCell*)cell;
-(void)removeCell:(AFTableCell*)cell;
-(void)removeAllCells;
-(int)cellCount;

+(UIColor*)headerColor;
+(UIColor*)headerShadowColor;
+(BOOL)headerShadowEnabled;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSMutableArray* children;
@property (nonatomic, retain) AFTable* parentTable;

@end
