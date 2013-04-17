//
// Created by augmental on 23/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define AFAssertMainThread()        NSAssert( [NSThread isMainThread], @"Only the main thread is allowed here!")
#define AFAssertBackgroundThread()  NSAssert(![NSThread isMainThread], @"The main thread is not allowed here!" )

#define AFCAssertMainThread()        NSCAssert( [NSThread isMainThread], @"Only the main thread is allowed here!")
#define AFCAssertBackgroundThread()  NSCAssert(![NSThread isMainThread], @"The main thread is not allowed here!" )