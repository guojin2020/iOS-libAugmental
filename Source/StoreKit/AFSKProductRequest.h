//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@protocol AFPSKProductConsumer;

@interface AFSKProductRequest : NSObject

-(id)initWithProductId:(NSString *)productId consumer:(id<AFPSKProductConsumer>)productConsumer;

@end