//
// Created by Chris Hatton on 20/04/2013.
//
#import <Foundation/Foundation.h>

@protocol AFPImageRenderer;

@interface AFRenderedImageView : UIImageView
{
	NSObject<AFPImageRenderer>* renderer;
}

- (id)initWithRenderer:(NSObject <AFPImageRenderer> *)rendererIn;

@end