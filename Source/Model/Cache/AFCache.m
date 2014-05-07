//
// Created by Chris Hatton on 05/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFCache.h"

@implementation AFCache
{
    NSCache* cache;
    AFCache * nextCache;
}

@synthesize nextCache;

- (id)init
{
    self = [super init];
    if (self)
    {
        cache = [NSCache new];
	    nextCache = NULL;
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
	[cache setObject:object forKey:key];
}


@end