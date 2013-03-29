#import "AFObjectTableCell.h"
#import "AFCellViewable.h"
#import "AFLogger.h"

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
    [object release];
    [cell release];
    [super dealloc];
}

- (void)setObject:(AFObject<AFCellViewable> *)objectIn
{
    AFObservable <AFCellViewable> *oldObject = object;
    object = [objectIn retain];
    [object addObserver:self];
    [oldObject removeObserver:self];
    [oldObject release];
}

- (UITableViewCell *)viewCellForTableView:(UITableView *)tableIn
{
    return nil;
}


@synthesize object;

@end
