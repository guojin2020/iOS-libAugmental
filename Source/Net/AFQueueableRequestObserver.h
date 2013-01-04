
#import "AFRequestObserver.h"

@class AFQueueableRequest;

@protocol AFQueueableRequestObserver <AFRequestObserver>

@required
- (void)requestQueued:(AFQueueableRequest*)requestIn AtPosition:(int)queuePosition;

@end
