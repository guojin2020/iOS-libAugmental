//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@protocol AFPSKProductConsumer;

@interface AFSKProductRequest : NSObject

@property(nonatomic, readonly) id<AFPSKProductConsumer> productConsumer;

-(id)initWithConsumer:(id<AFPSKProductConsumer>)productConsumer;

@end