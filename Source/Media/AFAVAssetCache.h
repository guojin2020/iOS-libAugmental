//
// Created by augmental on 14/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef struct AVCacheItem
{
    AVAsset* asset;
    NSUInteger referenceCount;
}
AVCacheItem;

@interface AFAVAssetCache : NSObject
{
    NSMutableDictionary* cacheItems;
}
+ (AFAVAssetCache *)sharedInstance;

- (AVAsset *)obtainAssetForURL:(NSURL *)assetURL;

- (bool)containsAsset:(NSURL *)assetURL;

- (void)releaseAsset:(NSURL *)assetURL;

@end