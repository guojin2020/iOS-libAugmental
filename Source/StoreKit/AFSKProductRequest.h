//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>

@protocol AFPSKProductConsumer;

@interface AFSKProductRequest : NSObject

@property(nonatomic, readonly) id<AFPSKProductConsumer> productConsumer;

-(id)initWithConsumer:(id<AFPSKProductConsumer>)productConsumer;

@end