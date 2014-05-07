//
// Created by augmental on 25/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>

@interface NSObject (SenTest)

- (void) failWithException:(NSException *) e;

@end