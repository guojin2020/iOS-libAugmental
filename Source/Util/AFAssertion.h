//
// Created by augmental on 23/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define AFAssertMainThread()        NSAssert( [[NSThread currentThread] isMainThread], @"Only the main thread is allowed here!")
#define AFAssertBackgroundThread()  NSAssert(![[NSThread currentThread] isMainThread], @"The main thread is not allowed here!" )