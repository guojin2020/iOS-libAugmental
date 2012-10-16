//
// Created by augmental on 14/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFVideoStillsFactory.h"
#import "AFAVAssetCache.h"

@implementation AFVideoStillsFactory
{
}

static AFVideoStillsFactory *sharedInstance;

+(AFVideoStillsFactory *)sharedInstance
{
    return sharedInstance ?: ( sharedInstance = [[AFVideoStillsFactory alloc] init]);
}

- (void)generateStillsFromURL:(NSURL *)url
                       ofSize:(CGSize)size
                      atTimes:(NSArray *)times
            completionHandler:(void (^)(NSDictionary *))handler
{
    AVAsset *asset = [[AFAVAssetCache sharedInstance] obtainAssetForURL:url];

    [self generateStillsFromAsset:asset
                           ofSize:size
                          atTimes:times
                completionHandler:handler];
}

- (void)generateStillsFromAsset:(AVAsset *)asset
                         ofSize:(CGSize)size
                        atTimes:(NSArray *)times
              completionHandler:(void (^)(NSDictionary *))handler
{
    NSAssert(asset!=nil, @"Asset must not be null");
    NSAssert(!CGSizeEqualToSize(size,CGSizeZero), @"You must request a non-zero image size");
    NSAssert([times count]>0, @"You must provide at least one time.");
    NSAssert(handler!= nil,@"You must provide a handler");

    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    Float64 durationSeconds = CMTimeGetSeconds([asset duration]);

    NSMutableArray* cmTimes = [[NSMutableArray alloc] initWithCapacity:[times count]];
    CMTime cmTime;
    for (NSNumber *time in times)
    {
        cmTime = CMTimeMakeWithSeconds((Float64)[time floatValue], 600);
        [cmTimes addObject:[NSValue valueWithCMTime:cmTime]];
    }

    NSMutableDictionary *images = [[NSMutableDictionary alloc] initWithCapacity:[cmTimes count]];

    [imageGenerator generateCGImagesAsynchronouslyForTimes:cmTimes completionHandler:
            ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
            {
                NSValue * requestedTimeValue = [NSValue valueWithCMTime:requestedTime];

                id object;
                switch(result)
                {
                    case AVAssetImageGeneratorSucceeded:
                        object = [[UIImage alloc] initWithCGImage:image];

                    case AVAssetImageGeneratorFailed:
                    case AVAssetImageGeneratorCancelled:
                        object = [NSNull null];
                        break;
                }

                [images setObject:object forKey:requestedTimeValue];

                [cmTimes removeObject:requestedTimeValue];
                if ([cmTimes count]==0)
                {
                    handler([images allValues]);

                    [cmTimes release];
                    [imageGenerator release];
                    [images release];
                }
            }];
}

@end