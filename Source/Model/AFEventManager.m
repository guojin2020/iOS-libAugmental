#import "AFEventObserver.h"
#import "AFEventManager.h"

@implementation AFEventManager

- (id)init
{
    if ((self = [super init]))
    {
        observers = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addObserver:(NSObject <AFEventObserver> *)observer
{
    [observers addObject:observer];
}

- (void)removeObserver:(NSObject <AFEventObserver> *)observer
{
    [observers removeObject:observer];
}

- (void)broadcastEvent:(AFEvent)type source:(NSObject *)source
{
    NSSet                           *observerCopy = [[NSSet alloc] initWithSet:observers];
    for (NSObject <AFEventObserver> *observer in observerCopy) [observer eventOccurred:type source:source];
    [observerCopy release];
}

- (void)dealloc
{
    [observers release];
    [super dealloc];
}

@end
