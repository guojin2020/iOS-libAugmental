//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>

@protocol AFPSKProductConsumer;

@interface AFSKProductRequest : NSObject

@property(nonatomic, readonly) NSObject<AFPSKProductConsumer>* productConsumer;

-(id)initWithConsumer:(NSObject<AFPSKProductConsumer>*)productConsumer;

@end