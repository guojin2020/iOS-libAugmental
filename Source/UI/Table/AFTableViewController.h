
#import <Foundation/Foundation.h>
#import "AFPObserver.h"

@class AFTable;
@class AFTableCell;

/**
 *	Generic framework-like class, providing an easy-to-use TableViewController
 *  which displays a table assembled from individual Cell and Section objects.
 */
@interface AFTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, AFPObserver>
{
	AFTable*    table;
	
	NSMutableDictionary*	headerViews;
	UITableViewCell*		returnCell;
	
	CGRect	normalTableFrame;
	BOOL	keyboardAnimating;
	
	UIButton*       doneButton;
	UITextField*    currentTextField;
    
    UIViewController* overrideParent;

    UITableViewStyle tableStyle;
}

/*
 * Convenience initialiser, equivalent to doing [init] then performing self.table = tableIn;
 */

-(id)initWithStyle:(UITableViewStyle)tableStyleIn;
-(id)initWithTable:(AFTable*)tableIn style:(UITableViewStyle)tableStyleIn;

-(void)setParentViewController:(UIViewController*)parentViewControllerIn;

-(void)reloadData;

-(AFTableCell*)tableCellForIndexPath:(NSIndexPath*)indexPath;

-(void)addButtonToKeyboard;

-(void)keyboardWillShow:(NSNotification*)notification;
-(void)keyboardDidShow:(NSNotification*)notification;
-(void)keyboardWillHide:(NSNotification*)note;
-(void)keyboardDidHide:(NSNotification*)notification;

- (void)textFieldDidEndEditing:(UITextField *)textField;

- (void)textFieldDidBeginEditing:(UITextField *)textField;


@property (nonatomic, retain) AFTable* table;
@property (nonatomic, retain) UIButton* doneButton;
//@property (nonatomic) UITableViewCellStyle cellStyle;

@end
