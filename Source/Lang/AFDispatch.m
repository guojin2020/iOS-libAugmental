#import "AFDispatch.h"

dispatch_queue_t AFBackgroundQueue = (dispatch_queue_t)0;

void AFInitializeBackgroundQueue()
{
	AFBackgroundQueue = dispatch_queue_create("AFBackgroundQueue", DISPATCH_QUEUE_SERIAL );
}