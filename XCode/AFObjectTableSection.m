
#import "AFObjectTableSection.h"
#import "AFObjectTableCell.h"
#import "AFObject_CellViewable.h"

@implementation AFObjectTableSection

-(id)initWithObjectArray:(NSArray*)objectArrayIn
{
	if((self = [self init]))
	{
		[self setObjectArray:objectArrayIn];
	}
	return self;
}

-(id)init
{
	if((self = [super init]))
	{
		objects = [[NSMutableArray alloc] init];
	}
	return self;
}

-(AFTableCell*)cellAtIndex:(NSInteger)index;
{
	return [super cellAtIndex:index];
}

-(void)addCell:(AFTableCell*)cell;
{
	[super addCell:cell];
	[objects addObject:cell];
}

-(NSObject<AFObjectTableCell>*)addObject:(NSObject<AFObject_CellViewable>*)object;
{
	Class<AFObjectTableCell> cellClass = [((Class<AFObject_CellViewable>)[object class]) cellViewClass];
	AFTableCell<AFObjectTableCell> *cell = [((AFTableCell<AFObjectTableCell>*)NSAllocateObject(cellClass, 0, NULL)) initWithObject:object];
	
	[children addObject:cell];
    cell.parentSection = self;
    [cell release];
    
	[objects addObject:object];
	
	return cell;
}


-(void)setObjectArray:(NSMutableArray*)objectArrayIn;
{
	[self removeAllCells];
	[self addObjectArray:objectArrayIn];
}

-(void)addObjectArray:(NSMutableArray*)objectArrayIn;
{
	for(NSObject<AFObject_CellViewable>* cellObject in objectArrayIn) [self addObject:cellObject];
}

-(void)removeAllCells
{
	[super removeAllCells];
	[objects removeAllObjects];
}

-(void)dealloc
{
	[objects release];
	[super dealloc];
}

@end
