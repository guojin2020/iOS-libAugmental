//
// Created by Chris Hatton on 14/10/2012.
// Contact: christopherhattonuk@gmail.com
//


#import "AFAVAssetCache.h"

@implementation AVCacheItem
@end

@implementation AFAVAssetCache

static AFAVAssetCache*defaultCache;

+(AFAVAssetCache*)sharedInstance
{
    return defaultCache ?: (defaultCache = [[AFAVAssetCache alloc] init]);
}

-(id)init
{
    self = [super init];
    if(self)
    {
        cacheItems = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(AVAsset*)obtainAssetForURL:(NSURL *)assetURL
{
    NSValue *itemPointer = [cacheItems objectForKey:assetURL];
    AVCacheItem* item;
    AVAsset *asset;

    if(itemPointer)
    {
        item = [itemPointer pointerValue];
        item.referenceCount++;
        asset = item.asset;
    }
    else
    {
        asset = [AVAsset assetWithURL:assetURL];

        item = [AVCacheItem new];

        item.asset          = asset;
        item.referenceCount = 1;

        [cacheItems setObject:[NSValue valueWithNonretainedObject:item] forKey:assetURL];
    }

    return asset;
}

-(bool)containsAsset:(NSURL *)assetURL
{
    return [cacheItems objectForKey:assetURL] != NULL;
}

-(void)releaseAsset:(NSURL*)assetURL
{
    NSValue *itemPointer = [cacheItems objectForKey:assetURL];

    if(itemPointer)
    {
        AVCacheItem* item = (AVCacheItem*)[itemPointer pointerValue];
        if(--item.referenceCount==0)
        {
            [cacheItems removeObjectForKey:assetURL];
        }
    }
}


@end