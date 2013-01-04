
#import <Foundation/Foundation.h>
#import "AFTableSection.h"
#import "AFObjectTableCell.h"

@protocol AFCellViewable;

@interface AFObjectTableSection : AFTableSection
{
    NSMutableArray *objects;
}

- (id)initWithObjectArray:(NSArray *)objectArrayIn;
- (AFObjectTableCell*)addObject:(AFObject<AFCellViewable> *)object;
- (void)setObjectArray:(NSArray *)objectArrayIn;
- (void)addObjectArray:(NSArray *)objectArrayIn;
- (void)removeAllCells;

@end
