
#import "AFRequest.h"

@interface AFQueueableRequest : AFRequest

- (void)requestWasQueuedAtPosition:(NSUInteger)queuePositionIn;
- (void)requestWasUnqueued;

@end
