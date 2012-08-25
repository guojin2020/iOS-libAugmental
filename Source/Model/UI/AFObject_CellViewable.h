#import "AFObject.h"

#import "AFObjectTableCell.h"

@protocol AFObject_CellViewable <AFObject>

+ (Class <AFObjectTableCell>)cellViewClass;

@end
