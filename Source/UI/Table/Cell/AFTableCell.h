
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFPThemeable.h"

#define DEFAULT_CELL_HEIGHT 22.0f

#define THEME_KEY_DEFAULT_TEXT_SIZE				@"textSize"
#define THEME_KEY_DEFAULT_TEXT_COLOR			@"textColor"
#define THEME_KEY_DEFAULT_SECONDARY_TEXT_COLOR  @"secondaryTextColor"
#define THEME_KEY_DEFAULT_TEXT_FONT				@"textFont"
#define THEME_KEY_DEFAULT_BG_COLOR				@"bgColor"
#define THEME_KEY_CELL_CLICKED_SOUND			@"beep-21"

@class AFTableSection;
@protocol AFCellSelectionDelegate;

/**
 *	Implementation of a basic Table cell for use in the Table framework classes.
 *	Uses the default UITableViewCell to display a line of text and a target object and
 *	selector to announce USER-touches.
 */
@interface AFTableCell : NSObject <AFPThemeable>
{
	UITableView*		tableView;
	UITableViewCell*	cell;
	UIColor*			fillColor;
	NSString*			labelText;
	NSObject<AFCellSelectionDelegate>*	selectionDelegate;
	
	AFTableSection* parentSection;
	
	CGFloat height;
}

-(id)initWithLabelText:(NSString*)labelTextIn;

-(NSString*)cellTemplateName;
-(CGFloat)heightForTableView:(UITableView*)tableIn;
-(UITableViewCell*)viewCellForTableView:(UITableView*)tableView;
-(UITableViewCell*)viewCellForTableView:(UITableView*)tableView templateName:(NSString*)templateNameIn;
-(void)wasSelected;
-(void)accessoryTapped;

-(void)refresh; // Refresh UI values from object

/**
 Informs the cell that delete has been selected. The cell may take appropriate action e.g. showing a confirmation dialog or changing its state somehow.
 Subclasses should implement an appropriate behaviour and return YES or NO depending on whether the cell should be removed from its parent table.
 This method is intended to be subclassed as it will never actually be called on AFTableCell because allowsDeletion always returns NO.
 */
-(BOOL)deleteSelected;
/**
 Determines whether this cell will display the Delete action button when it is swiped by the USER.
 This returns NO by default but may be subclassed to return YES by deletable cell types.
 The cell is polled to see whether it is deletable at creation time, so dynamically changing the
 return value after table creation will not reflected on the UI.
 */
-(BOOL)allowsDeletion;
-(NSString*)titleForDeleteButton;

-(void)willBeAdded;
-(void)willBeRemoved;

-(void)willAppear;
-(void)didDisappear;

-(void)setFillColor:(UIColor*)color;
-(UIColor*)fillColor;

+(UIColor*) defaultTextColor;
+(UIColor*) defaultBGColor;
+(UIFont*)  defaultTextFont;
+(float_t)  defaultTextSize;
+(NSString*)cellClickedSound;

-(void)viewCellDidLoad;

@property (nonatomic,retain) NSObject<AFCellSelectionDelegate>* selectionDelegate;
@property (nonatomic,retain) UITableViewCell* cell;
@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) AFTableSection* parentSection;
@property (nonatomic,readonly) UINavigationController* navigationController;
@property (nonatomic, retain) UIColor* fillColor;

@end
