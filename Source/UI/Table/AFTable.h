
#import <Foundation/Foundation.h>
#import "AFPObserver.h"
#import "AFObservable.h"
#import "AFThemeable.h"

@class AFTableSection;
@class AFTableViewController;

static AFChangeFlag* FLAG_TABLE_EDITED;

/**
 *	Generic framework-like class, representing an on-screen table
 *  which is assembled from individual Cell and Section objects.
 */
@interface AFTable : AFObservable <AFPObserver, NSFastEnumeration, AFThemeable>
{
	NSString*       title;
	NSMutableArray* children;
	NSString*       backTitle;
	
	AFTableViewController* viewController;
}

-(id)initWithTitle:(NSString*)titleIn;
-(id)initWithTitle:(NSString*)titleIn backTitle:(NSString*)backTitleIn;

-(void)addSection:(AFTableSection*)group;
-(void)removeSection:(AFTableSection*)group;

-(BOOL)containsSection:(AFTableSection*)section;

-(void)insertSection:(AFTableSection*)group atIndex:(int)index;

-(AFTableSection*)sectionAtIndex:(NSInteger)index;
-(NSInteger) sectionCount;
-(void)clear;

@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* backTitle;

@property (nonatomic,retain) AFTableViewController* viewController;
@property (nonatomic, readonly) UITableView* tableView;

@end