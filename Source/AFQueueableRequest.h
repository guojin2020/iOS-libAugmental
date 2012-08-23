
#import "AFRequest.h"

@protocol AFQueueableRequest <AFRequest>

-(void)requestQueuedAtPosition:(int)queuePosition;

@end
