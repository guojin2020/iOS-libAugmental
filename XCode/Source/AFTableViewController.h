
#import <Foundation/Foundation.h>
#import "AFEditableObserver.h"

@class AFTable;
@class AFTableCell;

/**
 *	Generic framework-like class, providing an easy-to-use TableViewController
 *  which displays a table assembled from individual Cell and Section objects.
 */
@interface AFTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AFEditableObserver>
{
	AFTable*		table;
	
	NSMutableDictionary*	headerViews;
	UITableViewCell*		returnCell;
	
	CGRect	normalTableFrame;
	BOOL	keyboardAnimating;
	
	UIButton *doneButton;
	UITextField* currentTextField;
	AFTableCell* currentTableCell;
    
    UIViewController* overrideParent;
}

/*
 * Convenience initialiser, equivalent to doing [init] then performing self.table = tableIn;
 */
-(id)initWithTable:(AFTable*)tableIn;

-(void)setParentViewController:(UIViewController*)parentViewControllerIn;

-(void)reloadData;

-(AFTableCell*)tableCellForIndexPath:(NSIndexPath*)indexPath;

-(void)addButtonToKeyboard;

-(void)keyboardWillShow:(NSNotification*)notification;
-(void)keyboardDidShow:(NSNotification*)notification;
-(void)keyboardWillHide:(NSNotification*)note;
-(void)keyboardDidHide:(NSNotification*)notification;

@property (nonatomic, retain) AFTable* table;
@property (nonatomic, retain) UIButton* doneButton;

@end
