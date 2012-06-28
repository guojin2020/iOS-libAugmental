
#import <Foundation/Foundation.h>
#import "AFEditableObserver.h"
#import "AFBlockEditableObject.h"
#import "AFThemeable.h"

@class AFTableSection;
@class AFTableViewController;

/**
 *	Generic framework-like class, representing an on-screen table
 *  which is assembled from individual Cell and Section objects.
 */
@interface AFTable : AFBlockEditableObject <AFEditableObserver, NSFastEnumeration, AFThemeable>
{
	NSString*       title;
	NSMutableArray* children;
	NSString*       backTitle;
	
	AFTableViewController* parentController;
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
@property (nonatomic,retain) AFTableViewController* parentController;

@end
