
#import "AFEventObserver.h"

@protocol AFObject_CellViewable;

@protocol AFObjectTableCell <AFEventObserver>

-(id)initWithObject:(NSObject<AFObject_CellViewable>*)objectIn;
-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn;
-(NSString*)cellReuseIdentifier;

@end
