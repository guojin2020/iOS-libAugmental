//
// Created by Chris Hatton on 20/04/2013.
//
#import <Foundation/Foundation.h>

@protocol AFPImageRenderer;

@interface AFRenderedImageCache : NSObject

+ (AFRenderedImageCache *)sharedInstance;

-(UIImage*)imageFromRenderer:(id<AFPImageRenderer>)renderer withSize:(CGSize)size;
- (void)purgeSizeCacheForRenderer:(id <AFPImageRenderer>)renderer;

@end