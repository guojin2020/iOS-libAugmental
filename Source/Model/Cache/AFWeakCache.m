//
// Created by augmental on 05/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AFWeakCache.h"
#import "AFObject.h"
#import "AFEventManager.h"


@implementation AFWeakCache
{
    NSMutableDictionary* dictionary;
}

-(void)addObject:(id<AFObject>)valueIn forKey:(id<AFObject>)keyIn
{
    NSValue
            *weakKey    = [NSValue valueWithPointer:keyIn],
            *weakValue  = [NSValue valueWithPointer:valueIn];

    [keyIn.eventManager addObserver:self];
    [valueIn.eventManager addObserver:self];

    [dictionary setObject:weakValue forKey:weakKey];
}

// AFEventObserver Implementation

- (void)eventOccurred:(AFEvent)type source:(id <AFObject>)source
{
    if(type== AFEventObjectDeallocating)
    {
        NSValue *deadWeakReference = [NSValue valueWithPointer:source];
        NSValue *weakKey, *weakValue;

        NSArray *keysSnapshot = [NSArray arrayWithArray:[dictionary allKeys]];
        for(id<AFObject> key in keysSnapshot)
        {
            weakKey     = (NSValue *)key;
            weakValue   = (NSValue *)[dictionary objectForKey:weakKey];

            [((id<AFObject>)[weakKey   pointerValue]) removeObserver:self];
            [((id<AFObject>)[weakValue pointerValue]) removeObserver:self];

            if([deadWeakReference isEqualToValue:weakKey] || [deadWeakReference isEqualToValue:weakValue])
            {
                [dictionary removeObjectForKey:weakKey];
            }
        }
    }
}

@end