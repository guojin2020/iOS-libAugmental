//
// Created by Chris Hatton on 14/10/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVCacheItem : NSObject
@property (copy) AVAsset* asset;
@property NSUInteger referenceCount;
@end 

@interface AFAVAssetCache : NSObject
{
    NSMutableDictionary* cacheItems;
}
+ (AFAVAssetCache *)sharedInstance;

- (AVAsset *)obtainAssetForURL:(NSURL *)assetURL;

- (bool)containsAsset:(NSURL *)assetURL;

- (void)releaseAsset:(NSURL *)assetURL;

@end