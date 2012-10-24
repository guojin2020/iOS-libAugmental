#import "AFRequest.h"

@protocol AFQueueableRequest <AFRequest>

- (void)requestWasQueuedAtPosition:(NSUInteger)queuePositionIn;
- (void)requestWasUnqueued;

@end
