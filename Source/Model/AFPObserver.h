//
//  AFObserver.h
//  iOS-libAugmental
//
//  Created by Chris Hatton on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFEvent;
@class AFObservable;
@class AFEvent;

@protocol AFPObserver <NSObject>

- (void)change:(AFEvent *)changeFlag wasFiredBySource:(AFObservable *)observable withParameters:(NSArray *)parameters;

@end
