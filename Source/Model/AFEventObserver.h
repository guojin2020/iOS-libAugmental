@protocol AFObject;
typedef enum AFAppEvent
{
    AFEventAppSettingsLoaded     = 1,
    AFEventAppTerminating        = 2,
    AFEventObjectFieldUpdated    = 3,
    AFEventObjectInvalidated     = 4,
    AFEventObjectValidated       = 5,
    AFEventAppSettingsLoadFailed = 6,
    AFEventAppMemoryWarning      = 7,
    AFEventBasketItemsChanged    = 8,
    AFEventObjectDeallocating = 9
}
AFAppEvent;

/**
 This protocol describes an object which can respond to a AFEvent.
 */
@protocol AFEventObserver

/**
 Called on an object when the specified AFEvent is broadcast by AFEventManager.
 */
- (void)eventOccurred:(AFAppEvent)type source:(id <AFObject>)source;

@end
