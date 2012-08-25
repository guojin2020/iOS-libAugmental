typedef enum event
{
    APP_SETTINGS_LOADED      = 1,
    APP_TERMINATING          = 2,
    OBJECT_FIELD_UPDATED     = 3,
    OBJECT_INVALIDATED       = 4,
    OBJECT_VALIDATED         = 5,
    APP_SETTINGS_LOAD_FAILED = 6,
    APP_MEMORY_WARNING       = 7,
    BASKET_ITEMS_CHANGED     = 8
}
        event;

/**
 This protocol describes an object which can respond to a AFEvent.
 */
@protocol AFEventObserver

/**
 Called on an object when the specified AFEvent is broadcast by AFEventManager.
 */
- (void)eventOccurred:(event)type source:(NSObject *)source;
//-(BOOL)respondsToEventType:(Class<AFEvent>*)event;

@end
