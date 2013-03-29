
#import "AFWeakCache.h"
#import "AFObject.h"
#import "AFLogger.h"

@implementation AFWeakCache
{
    NSMutableDictionary* dictionary;
}

-(void)addObject:(AFObject*)valueIn forKey:(AFObject*)keyIn
{
    NSValue
            *weakKey    = [NSValue valueWithPointer:keyIn],
            *weakValue  = [NSValue valueWithPointer:valueIn];

    [keyIn addObserver:self];
    [valueIn addObserver:self];

    [dictionary setObject:weakValue forKey:weakKey];
}

-(void)handleObjectDeallocating:(id)object
{
    AFLogPosition();

    NSValue *deadWeakReference = [NSValue valueWithPointer:object];
    NSValue *weakKey, *weakValue;

    NSArray *keysSnapshot = [NSArray arrayWithArray:[dictionary allKeys]];
    for(AFObject* key in keysSnapshot)
    {
        weakKey     = (NSValue *)key;
        weakValue   = (NSValue *)[dictionary objectForKey:weakKey];

        [((AFObject*)[weakKey   pointerValue]) removeObserver:self];
        [((AFObject*)[weakValue pointerValue]) removeObserver:self];

        if([deadWeakReference isEqualToValue:weakKey] || [deadWeakReference isEqualToValue:weakValue])
        {
            [dictionary removeObjectForKey:weakKey];
        }
    }
}

@end