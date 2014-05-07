//
// Created by Chris Hatton on 20/04/2013.
//
#import <Foundation/Foundation.h>

@protocol AFPImageRenderer <NSObject>

-(UIImage *)newImageForSize:(CGSize)size;

@end