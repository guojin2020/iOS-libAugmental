
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
 *	Implementation of a basic Table _viewCell for use in the Table framework classes.
 *	Uses the default UITableViewCell to display a line of text and a target object and
 *	selector to announce USER-touches.
 */
@interface AFTableCell : NSObject <AFPThemeable>

@property NSString* labelText;
@property (readonly) UITableViewCell* viewCell;
@property (readonly) UITableView* tableView;
@property (weak) AFTableSection* parentSection;
@property (weak, readonly) UINavigationController* navigationController;
@property NSObject<AFCellSelectionDelegate>* selectionDelegate;
@property UIColor* fillColor;

-(id)initWithLabelText:(NSString*)labelTextIn;

-(NSString*)cellTemplateName;
-(CGFloat)heightForTableView:(UITableView*)tableIn;
-(UITableViewCell*)viewCellForTableView:(UITableView*)tableView;
-(UITableViewCell*)viewCellForTableView:(UITableView*)tableView templateName:(NSString*)templateNameIn;

-(void)wasSelected;
-(void)accessoryTapped;

-(void)refresh; // Refresh UI values from object

/**
 Informs the _viewCell that delete has been selected. The _viewCell may take appropriate action e.g. showing a confirmation dialog or changing its state somehow.
 Subclasses should implement an appropriate behaviour and return YES or NO depending on whether the _viewCell should be removed from its parent table.
 This method is intended to be subclassed as it will never actually be called on AFTableCell because allowsDeletion always returns NO.
 */
-(BOOL)deleteSelected;
/**
 Determines whether this _viewCell will display the Delete action button when it is swiped by the USER.
 This returns NO by default but may be subclassed to return YES by deletable _viewCell types.
 The _viewCell is polled to see whether it is deletable at creation time, so dynamically changing the
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

@end
