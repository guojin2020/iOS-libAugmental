//
// Created by augmental on 05/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface AFCache : NSObject

@property(nonatomic, retain) AFCache *nextCache;

- (NSObject*)objectForKey:(NSObject *)key;

- (void)setObject:(NSObject *)object forKey:(NSObject *)key;

- (void)purgeCache;

@end