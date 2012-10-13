#import "AFObject.h"

#import "AFObjectTableCell.h"

@protocol AFObject_CellViewable <AFObject>

+ (id<AFObjectTableCell>)cellViewClass;

@end
