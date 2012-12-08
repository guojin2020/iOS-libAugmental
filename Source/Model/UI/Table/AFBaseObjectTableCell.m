#import "AFBaseObjectTableCell.h"
#import "AFObject_CellViewable.h"
#import "AFEventManager.h"

@implementation AFBaseObjectTableCell

- (id)initWithObject:(NSObject <AFObject_CellViewable> *)objectIn
{
    if ((self = [self init]))
    {
        self.object = objectIn;
    }
    return self;
}

- (void)setTagReferences
{[self doesNotRecognizeSelector:_cmd];}

- (void)refreshFields
{[self doesNotRecognizeSelector:_cmd];}

- (void)eventOccurred:(AFAppEvent)type source:(id <AFObject>)source
{
    if (type == (AFAppEvent) AFEventObjectFieldUpdated)[self refreshFields];
}

- (NSString *)cellReuseIdentifier
{
    return [NSString stringWithFormat:@"%@%i", NSStringFromClass([object class]), object.primaryKey];
}

- (void)dealloc
{
    [object.eventManager removeObserver:self];
    [object release];
    [cell release];
    [super dealloc];
}

- (void)setObject:(NSObject <AFObject_CellViewable> *)objectIn
{
    NSObject <AFObject_CellViewable> *oldObject = object;
    object = [objectIn retain];
    [object.eventManager addObserver:self];
    [oldObject.eventManager removeObserver:self];
    [oldObject release];
}

@synthesize object;

@end
