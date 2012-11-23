//
// Created by Chris Hatton on 05/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>
#import "AFEventObserver.h"

@protocol AFObject;

@interface AFWeakCache : NSObject <AFEventObserver>

- (void)addObject:(id <AFObject>)valueIn forKey:(id <AFObject>)keyIn;

@end