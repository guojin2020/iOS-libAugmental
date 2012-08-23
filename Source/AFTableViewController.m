#import <CoreGraphics/CoreGraphics.h>
#import "AFTableViewController.h"

#import "AFScreen.h"
#import "AFTable.h"
#import "AFTableSection.h"
#import "AFCellSelectionDelegate.h"
#import "AFObservable.h"
#import "AFTableCellBackgroundView.h"

@interface AFTableViewController ()

-(void)scrollToCurrentTextField;

@end

CGRect CGRectMakePair(CGPoint location, CGSize size);
CGRect CGRectMakePair(CGPoint location, CGSize size)
{
    return CGRectMake(location.x, location.y, size.width, size.height);
}

@implementation AFTableViewController

-(id)initWithStyle:(UITableViewStyle)tableStyleIn
{
	if((self = [super init]))
	{
        tableStyle          = tableStyleIn;
		table				= nil;
		headerViews			= [[NSMutableDictionary alloc] init];
		keyboardAnimating	= NO;
		currentTextField	= nil;
        overrideParent      = nil;
	}
	return self;
}

-(id)initWithTable:(AFTable*)tableIn style:(UITableViewStyle)tableStyleIn
{
	if((self = [self initWithStyle:tableStyleIn]))
	{
		self.table = tableIn;
	}
	return self;
}

-(UIViewController*)parentViewController
{
    return overrideParent?overrideParent:[super parentViewController];
}

-(void)setParentViewController:(UIViewController*)parentViewControllerIn
{
    UIViewController* oldOverrideParent = overrideParent;
    overrideParent = [parentViewControllerIn retain];
    [oldOverrideParent release];
}

-(void)reloadData
{
	[self.view performSelector:@selector(reloadData)];
	//[self.view performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)change:(AFChangeFlag*)changeFlag wasFiredBySource:(AFObservable*)observable withParameters:(NSArray*)parameters
{
    
}

-(void)setTable:(AFTable*)tableIn
{
	AFTable* oldTable = table;
	table = [tableIn retain];
	[oldTable removeObserver:(id<AFPObserver>)self];
	[tableIn addObserver:(id<AFPObserver>)self];
	[oldTable release];
	//[self editableChanged:table];
	table.viewController = self;
	self.title = table.title;
    
	if(table.backTitle)
	{
		UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:table.backTitle style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release];
	}
	
	//if([self isViewLoaded])[self editableChanged:table];
    if([self isViewLoaded])[self editableChanged:self];
}

- (UITableViewStyle)cellStyle { return tableStyle; }


-(void)editableChanged:(AFObservable*)changedTable
{
	NSAssert(changedTable==table,@"Internal inconsistency");
	
	self.title = table.title;
	if([self isViewLoaded]) [self reloadData];
}

-(void)loadView
{
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableStyle];

    tableView.separatorColor = [UIColor colorWithWhite:0.25 alpha:1];

    tableView.dataSource = self;
	tableView.delegate = self;
	tableView.showsVerticalScrollIndicator = YES;
	tableView.showsHorizontalScrollIndicator = NO;

	self.view = tableView;

   tableView.opaque = NO;

	[tableView release];
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"Table frame on display: %@", NSStringFromCGRect(self.view.frame));
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[((UITableView*)self.view) flashScrollIndicators];
	//NSLog(@"Table view didAppear: %@, navController: %@",self.view,self.navigationController);
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardDidShow:) 
													 name:UIKeyboardDidShowNotification 
												   object:nil];		
	}
	else
	{
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
	}
}

-(void)viewWillDisappear:(BOOL)animated
{
	[currentTextField resignFirstResponder]; //Dismiss any keyboard
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
	return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString* title = [self tableView:tableView titleForHeaderInSection:section];
	
	if(!tableView || !title || [title isEqualToString:@""])
	{
		return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	}
		
	UIView* headerView = [headerViews objectForKey:title];
	if(!headerView)
	{
		headerView					= [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, [self tableView:tableView heightForHeaderInSection:section])];
		
		UILabel* headerLabel		= [[UILabel alloc] initWithFrame:CGRectZero];
		headerLabel.backgroundColor	= [UIColor clearColor];
		headerLabel.textColor		= [AFTableSection headerColor];
		headerLabel.frame			= CGRectMake(12.0, 0.0, 300.0, [self tableView:tableView heightForHeaderInSection:section]);
		headerLabel.transform		= CGAffineTransformMakeTranslation(0, -3);
		headerLabel.text			= title;
		headerLabel.opaque			= NO;
		headerLabel.highlightedTextColor = [AFTableSection headerColor];
		
		headerLabel.shadowColor		= [AFTableSection headerShadowEnabled]?[AFTableSection headerShadowColor]:[UIColor clearColor];
		headerLabel.shadowOffset	= [AFTableSection headerShadowEnabled]?CGSizeMake(1, 1):CGSizeMake(0, 0);
		
		[headerView addSubview:headerLabel];
		[headerLabel release];
		[headerViews setObject:headerView forKey:title];
		[headerView release];
	}
	return headerView;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{return [[table sectionAtIndex:section].title length]>0?22.0f:0.0;}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{return 0.0;}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return [[self tableCellForIndexPath:indexPath] heightForTableView:tableView];
}

-(void)tableView:(UITableView*)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath
{
	if(table)[[self tableCellForIndexPath:indexPath] accessoryTapped];
}

-(NSIndexPath*)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	return indexPath;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[[self tableCellForIndexPath:indexPath] wasSelected];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(table)[[table sectionAtIndex:indexPath.section] beginAtomic];
}

-(void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(table)[[table sectionAtIndex:indexPath.section] completeAtomic];
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return table && [[self tableCellForIndexPath:indexPath] allowsDeletion]?UITableViewCellEditingStyleDelete:UITableViewCellEditingStyleNone;
}

-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return table?[[self tableCellForIndexPath:indexPath] titleForDeleteButton]:nil;
}

-(BOOL)tableView:(UITableView*)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath*)indexPath{return NO;}

-(NSIndexPath*)tableView:(UITableView*)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath*)sourceIndexPath toProposedIndexPath:(NSIndexPath*)proposedDestinationIndexPath
{
	return sourceIndexPath;
}

-(AFTableCell*)tableCellForIndexPath:(NSIndexPath*)indexPath 
{
	return table?[[table sectionAtIndex:indexPath.section] cellAtIndex:indexPath.row]:nil;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	AFTableCell* usefulCell = [self tableCellForIndexPath:indexPath];
	returnCell = usefulCell?[usefulCell viewCellForTableView:(UITableView*)(self.view)]:nil;
	if(!returnCell) returnCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]; //[NSString stringWithFormat:@"%i%i",indexPath.section,indexPath.row]

	int sectionCells = [[table sectionAtIndex:indexPath.section] cellCount];
	
	if([usefulCell.cell.backgroundView isKindOfClass:[AFTableCellBackgroundView class]])
	{
		const AFTableCellBackgroundView* bgView = (AFTableCellBackgroundView*)(usefulCell.cell.backgroundView);
		TableCellBackgroundViewPosition oldPosition = bgView.position;
		
		if(sectionCells==1)						bgView.position = (TableCellBackgroundViewPosition)TableCellBackgroundViewPositionSingle;
		else if(indexPath.row==0)				bgView.position = (TableCellBackgroundViewPosition)TableCellBackgroundViewPositionTop;
		else if(indexPath.row==sectionCells-1)	bgView.position = (TableCellBackgroundViewPosition)TableCellBackgroundViewPositionBottom;
		else									bgView.position = (TableCellBackgroundViewPosition)TableCellBackgroundViewPositionMiddle;
		
		if(bgView.position!=oldPosition)
		{
			[bgView setNeedsDisplay];
		}
	}
	
	return returnCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	//NSAssert(tableView==self.view,@"Wrong table view!");
	return table?[table sectionCount]:0;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSAssert(tableView==self.view,@"Wrong table view!");
	NSArray* rows = [table sectionAtIndex:section].children;
	int rowCount = [rows count];
	return table?rowCount:0;
}

-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
	return table?[[table sectionAtIndex:section] title]:nil;
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if(editingStyle==UITableViewCellEditingStyleDelete)
	{
		AFTableCell* cell = [self tableCellForIndexPath:indexPath];
		if([cell deleteSelected])
		{
			[[table sectionAtIndex:indexPath.section] removeCell:cell];
		}
	}
}

-(BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
	return table?[[self tableCellForIndexPath:indexPath] allowsDeletion]:NO;
}

-(BOOL)tableView:(UITableView*)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath{return NO;}
-(void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath*)toIndexPath{}

-(void)tableView:(UITableView*)tableView didUpdateTextFieldForRowAtIndexPath:(NSIndexPath*)indexPath withValue:(NSString*)newValue{}

//====================================>> Numeric Keypad 'Done' button enhancement

-(void)addButtonToKeyboard
{
	//Create custom button
	if(!doneButton)
	{
		self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
		doneButton.frame = CGRectMake(0, 163, 106, 53);
		doneButton.adjustsImageWhenHighlighted = NO;
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0)
		{
			[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
			[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
		}
		else
		{        
			[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
			[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
		}
		[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	// locate keyboard view
	NSArray* windows = [[UIApplication sharedApplication] windows];
	if([windows count]>1)
	{
		UIWindow* tempWindow = [windows objectAtIndex:1];
		UIView* keyboard;
		for(int i=0; i<[tempWindow.subviews count]; i++)
		{
			keyboard = [tempWindow.subviews objectAtIndex:i];
			// keyboard found, add the button
			if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
			{
				if([[keyboard description] hasPrefix:@"<UIPeripheralHost"]==YES)[keyboard addSubview:doneButton];
			}
			else
			{
				if([[keyboard description] hasPrefix:@"<UIKeyboard"]==YES)[keyboard addSubview:doneButton];
			}
		}
	}
}

//====================================>> Keyboard Notification Handling Start

-(void)keyboardWillShow:(NSNotification*)notification
{
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2 && currentTextField.keyboardType==UIKeyboardTypeNumberPad)
	{
		[self addButtonToKeyboard];
	}
	
    CGRect keyboardRect;
	CGPoint keyboardBegin;
	CGPoint keyboardEnd;
    
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

    
	[[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardRect];
	[[[notification userInfo] objectForKey:UIKeyboardCenterBeginUserInfoKey] getValue:&keyboardBegin];
	[[[notification userInfo] objectForKey:UIKeyboardCenterEndUserInfoKey] getValue:&keyboardEnd];
	
#pragma GCC diagnostic warning "-Wdeprecated-declarations" 
    
	if(!keyboardAnimating)
	{
		keyboardAnimating = YES;
		
		// Start animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishAnimation:finished:context:)];
		
		normalTableFrame = self.view.frame;
		CGRect newTableFrame = normalTableFrame;
		
		float screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
		float keyboardHeight = keyboardRect.size.height;
		float navigationBarHeight = self.navigationController.navigationBar.bounds.size.height;
		
		newTableFrame.size.height = screenHeight - keyboardHeight - navigationBarHeight;
		
		self.view.frame = newTableFrame;
		
		[UIView commitAnimations];
	}
}

//Once the view area has finished shrinking or growing, make sure any currently selected text field remains scrolled to visible
-(void)finishAnimation:(NSString*)animationId finished:(BOOL)finished context:(void*)context
{
    [self scrollToCurrentTextField];
}

-(void)scrollToCurrentTextField
{
	CGRect targetRect = [currentTextField.superview convertRect:currentTextField.frame toView:self.view];
	if(currentTextField)[((UIScrollView*)(self.view)) scrollRectToVisible:targetRect animated:YES];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
	keyboardAnimating = NO;
	
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2  && currentTextField.keyboardType==UIKeyboardTypeNumberPad)
	{
		[self addButtonToKeyboard];
    }
}

-(void)keyboardWillHide:(NSNotification*)note
{
	if(!keyboardAnimating)
	{
		keyboardAnimating = YES;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		// Apply new size of table view
		self.view.frame = normalTableFrame;
		
		[UIView commitAnimations];
	}
}

-(void)keyboardDidHide:(NSNotification*)notification{keyboardAnimating = NO;}

-(void)doneButton:(id)sender{[currentTextField resignFirstResponder];}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	currentTextField = textField;
	
	[self scrollToCurrentTextField];
	
	if(textField.keyboardType==UIKeyboardTypeNumberPad) [self addButtonToKeyboard];
	else [doneButton removeFromSuperview];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
	currentTextField = nil;
}

//=========================================>> Keyboard Notification Handling End

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[returnCell release];
	[headerViews release];
	[table release];
    [overrideParent release];
    [doneButton release];
    [super dealloc];
}

@synthesize table, doneButton;

@end
