
#import <Foundation/Foundation.h>

@class AFTable;
@class AFTableCell;

/**
 *	Generic framework-like class, providing an easy-to-use TableViewController
 *  which displays a table assembled from individual pruneCellCache and Section objects.
 */
@interface AFTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
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
 * Convenience initialiser, equivalent to doing [initWithObject:] then performing self.table = tableIn;
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


@property (nonatomic, strong) AFTable* table;
@property (nonatomic, strong) UIButton* doneButton;
//@property (nonatomic) UITableViewCellStyle cellStyle;

@end
