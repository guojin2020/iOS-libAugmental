
#import <Foundation/Foundation.h>
#import "AFObservable.h"
#import "AFPObserver.h"
#import "AFThemeable.h"

@class AFTableSection;
@class AFTableViewController;

extern AFChangeFlag *FLAG_TABLE_EDITED;

/**
 *	Generic framework-like class, representing an on-screen table
 *  which is assembled from individual pruneCellCache and Section objects.
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

-(void)insertSection:(AFTableSection*)group atIndex:(NSUInteger)index;

-(AFTableSection*)sectionAtIndex:(NSUInteger)index;
-(NSUInteger) sectionCount;
-(void)clear;

@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* backTitle;

@property (nonatomic,retain) AFTableViewController* viewController;
@property (nonatomic, readonly) UITableView* tableView;

@end
