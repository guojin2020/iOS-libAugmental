//
// Created by Chris Hatton on 05/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFWeakCache.h"
#import "AFObject.h"
#import "AFObservable.h"

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