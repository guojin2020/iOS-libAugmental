#import "AFObjectTableSection.h"
#import "AFCellViewable.h"

@implementation AFObjectTableSection

- (id)initWithObjectArray:(NSArray *)objectArrayIn
{
    if ((self = [self init]))
    {
        [self setObjectArray:objectArrayIn];
    }
    return self;
}

- (id)init
{
    if ((self = [super init]))
    {
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (AFTableCell *)cellAtIndex:(NSUInteger)index;
{
    return [super cellAtIndex:(NSUInteger) index];
}

- (void)addCell:(AFTableCell *)cell;
{
    [super addCell:cell];
    [objects addObject:cell];
}

- (AFObjectTableCell*)addObject:(AFObject<AFCellViewable>*)object;
{
    Class cellClass = [((id<AFCellViewable>) [object class]) cellViewClass];
    AFObjectTableCell *cell = [((AFObjectTableCell*) NSAllocateObject(cellClass, 0, NULL)) initWithObject:object];

    [children addObject:cell];
    cell.parentSection = self;
    [cell release];

    [objects addObject:object];

    return cell;
}


- (void)setObjectArray:(NSArray *)objectArrayIn;
{
    [self removeAllCells];
    [self addObjectArray:objectArrayIn];
}

- (void)addObjectArray:(NSArray *)objectArrayIn;
{
    for (AFObject<AFCellViewable> *cellObject in objectArrayIn) [self addObject:cellObject];
}

- (void)removeAllCells
{
    [super removeAllCells];
    [objects removeAllObjects];
}

- (void)dealloc
{
    [objects release];
    [super dealloc];
}

@end
