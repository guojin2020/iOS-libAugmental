//
// Created by Chris Hatton on 05/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>

@interface AFCache : NSObject

@property(nonatomic, retain) AFCache *nextCache;

- (NSObject*)objectForKey:(NSObject *)key;

- (void)setObject:(NSObject *)object forKey:(NSObject *)key;

@end