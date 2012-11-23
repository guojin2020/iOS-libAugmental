//
// Created by Chris Hatton on 05/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFCache.h"

@implementation AFCache
{
    NSMutableDictionary* cache;

    AFCache * nextCache;
}

@synthesize nextCache;

- (id)init
{
    self = [super init];
    if (self)
    {
        cache = [[NSMutableDictionary alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(purgeCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }

    return self;
}

-(NSObject*)objectForKey:(NSObject *)key
{
    NSObject *object = [cache objectForKey:key];
    if(!object && nextCache) object = [nextCache objectForKey:key];
    return object;
}

-(void)setObject:(NSObject*)object forKey:(NSObject*)key
{
    CFDictionarySetValue((CFMutableDictionaryRef)cache, key, object);
}

-(void)purgeCache
{
    NSObject *object;
    NSArray *cacheKeysSnapshot = [[NSArray alloc] initWithArray:[cache allKeys]];
    for(NSObject *key in cacheKeysSnapshot)
    {
        object = cache[key];
        if([object retainCount]==1)
        {
            [cache removeObjectForKey:key];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
    [cache release];
    [nextCache release];
    [super dealloc];
}

@end