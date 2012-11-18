//
// Created by augmental on 18/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface AFDefaultsBackedStringDictionary : NSMutableDictionary

- (id)initWithDefaultsKey:(NSString *)defaultsKeyIn;

- (void)synchronize;

@end