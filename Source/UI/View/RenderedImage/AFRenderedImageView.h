//
// Created by Chris Hatton on 20/04/2013.
//
#import <Foundation/Foundation.h>

@protocol AFPImageRenderer;

@interface AFRenderedImageView : UIImageView
{
	id<AFPImageRenderer> renderer;
}

- (id)initWithRenderer:(id<AFPImageRenderer>)rendererIn;

@property (nonatomic, retain) id<AFPImageRenderer> renderer;

@end