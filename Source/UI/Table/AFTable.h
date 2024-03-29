
#import <Foundation/Foundation.h>
#import "AFObservable.h"
#import "AFPThemeable.h"

@class AFTableSection;
@class AFTableViewController;

extern SEL AFTableEventEdited;

/**
 *	Generic framework-like class, representing an on-screen table
 *  which is assembled from individual pruneCellCache and Section objects.
 */
@interface AFTable : AFObservable <NSFastEnumeration, AFPThemeable>
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

@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* backTitle;

@property (nonatomic,strong) AFTableViewController* viewController;
@property (weak, nonatomic, readonly) UITableView* tableView;

@end
