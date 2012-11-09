#import "AFEventObserver.h"

/**
 An AFEventManager is a simple pool of observers which AFEvents may
 be broadcast to.
 */
@interface AFEventManager : NSObject
{
    NSMutableSet *observers;
}

/**
 Add an observer to the pool.
 */
- (void)addObserver:(NSObject <AFEventObserver> *)observer;

/**
 Remove an observer from the pool.
 */
- (void)removeObserver:(NSObject <AFEventObserver> *)observer;

/**
 Notify all observers in the pool of the specified AFEvent.
 */
- (void)broadcastEvent:(AFEvent)type source:(id <AFObject>)source;

@end
