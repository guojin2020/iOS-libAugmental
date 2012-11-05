//
// Created by augmental on 05/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFEventObserver.h"

@protocol AFObject;

@interface AFWeakObjectDictionary : NSObject <AFEventObserver>

- (void)addObject:(id <AFObject> *)valueIn forKey:(id <AFObject> *)keyIn;

@end