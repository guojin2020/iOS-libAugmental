//
// Created by augmental on 14/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AFVideoStillsFactory : NSObject

+ (AFVideoStillsFactory *)sharedInstance;

- (void)generateStillsFromURL:(NSURL *)url
                       ofSize:(CGSize)size
                      atTimes:(NSArray *)times
            completionHandler:(void (^)(NSDictionary *))handler;

- (void)generateStillsFromAsset:(AVAsset *)asset
                         ofSize:(CGSize)size
                        atTimes:(NSArray *)times
              completionHandler:(void (^)(NSDictionary *))handler;

@end