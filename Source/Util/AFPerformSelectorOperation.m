#import "AFPerformSelectorOperation.h"

static NSOperationQueue *backgroundOperationQueue = nil;

@implementation AFPerformSelectorOperation

- (id)initWithTarget:(id)targetIn selector:(SEL)selectorIn object:(id)objectIn
{
    if ((self = [self init]))
    {
        target   = [targetIn retain];
        selector = selectorIn;
        object   = [objectIn retain];
    }
    return self;
}

- (void)main
{
    //NSLog(@"%@ response to selector %@? %i",target,NSStringFromSelector(selector),[target respondsToSelector:selector]);
    [target performSelector:selector withObject:object];
}

+ (NSOperationQueue *)backgroundOperationQueue
{
    if (!backgroundOperationQueue)
    {
        backgroundOperationQueue = [[NSOperationQueue alloc] init];
        [backgroundOperationQueue setMaxConcurrentOperationCount:1];
    }
    return backgroundOperationQueue;
}

- (void)dealloc
{
    [target release];
    [object release];
    [super dealloc];
}

@end

@implementation NSObject (AFPerformSelectorOperation)

- (NSOperation *)performSelectorOnCommonBackgroundThread:(SEL)selector withObject:(id)object
{
    NSOperation *operation = [[AFPerformSelectorOperation alloc] initWithTarget:self selector:selector object:object];
    [[AFPerformSelectorOperation backgroundOperationQueue] addOperation:operation];
    [operation release];
    return operation;
}

@end
