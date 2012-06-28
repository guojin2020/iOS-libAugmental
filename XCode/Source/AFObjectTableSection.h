
#import <Foundation/Foundation.h>
#import "AFTableSection.h"
#import "AFObjectTableCell.h"

@protocol AFObject_CellViewable;

@interface AFObjectTableSection : AFTableSection
{
	//NSMutableDictionary* childCellMap;
	NSMutableArray* objects;
}

-(id)initWithObjectArray:(NSArray*)objectArrayIn;
-(NSObject<AFObjectTableCell>*)addObject:(NSObject<AFObject_CellViewable>*)object;
-(void)setObjectArray:(NSArray*)objectArrayIn;
-(void)addObjectArray:(NSMutableArray*)objectArrayIn;
-(void)removeAllCells;


@end
