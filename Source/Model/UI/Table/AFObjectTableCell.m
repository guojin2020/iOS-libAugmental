#import "AFObjectTableCell.h"
#import "AFCellViewable.h"
#import "AFLog.h"

@implementation AFObjectTableCell

- (id)initWithObject:(AFObject <AFCellViewable> *)objectIn
{
    if ((self = [self init]))
    {
        self.object = objectIn;
    }
    return self;
}

- (void)setTagReferences
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)refreshFields
{
    [self doesNotRecognizeSelector:_cmd];
}

-(void)handleObjectFieldUpdated:(AFObject*)objectIn
{
    AFLogPosition();
    [self refreshFields];
}

- (NSString *)cellReuseIdentifier
{
    return [NSString stringWithFormat:@"%@%i", NSStringFromClass([object class]), object.primaryKey];
}

- (void)dealloc
{
    [object removeObserver:self];
}

- (void)setObject:(AFObject<AFCellViewable> *)objectIn
{
    AFObservable <AFCellViewable> *oldObject = object;
    object = objectIn;
    [object addObserver:self];
    [oldObject removeObserver:self];
}

- (UITableViewCell *)viewCellForTableView:(UITableView *)tableIn
{
    return nil;
}


@synthesize object;

@end
