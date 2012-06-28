
#import "AFRequestObserver.h"

@protocol AFQueueableRequest;

@protocol AFQueueableRequestObserver <AFRequestObserver>

@required
-(void)requestQueued:(NSObject<AFQueueableRequest>*)requestIn AtPosition:(int)queuePosition;

@end
