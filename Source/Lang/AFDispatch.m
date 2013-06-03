
#import "AFDispatch.h"

dispatch_queue_t AFBackgroundQueue;

void AFInitializeBackgroundQueue()
{
	//AFBackgroundQueue = dispatch_queue_create( "AFBackgroundQueue", DISPATCH_QUEUE_SERIAL );
	AFBackgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 );
}