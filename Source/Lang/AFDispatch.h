
#import <dispatch/dispatch.h>

/**
* Globally available dispatch queue for serial background operations
*/
extern dispatch_queue_t AFBackgroundQueue;

#define AFBeginMainDispatch(BLOCK)       dispatch_async( dispatch_get_main_queue(), BLOCK )
#define AFBeginBackgroundDispatch(BLOCK) dispatch_async( AFBackgroundQueue, BLOCK )

#define AFMainDispatch(BLOCK)            dispatch_sync(dispatch_get_main_queue(), BLOCK )
#define AFBackgroundDispatch(BLOCK)      dispatch_sync( AFBackgroundQueue, BLOCK )

/**
* Must be called, only once, before AFBeginBackgroundDispatch() is used
* e.g. during Application initialization.
*/
void AFInitializeBackgroundQueue(void);