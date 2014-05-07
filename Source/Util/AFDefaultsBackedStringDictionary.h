//
// Created by Chris Hatton on 18/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>

@interface AFDefaultsBackedStringDictionary : NSMutableDictionary

- (id)initWithDefaultsKey:(NSString *)defaultsKeyIn;
- (void)synchronize;

@end