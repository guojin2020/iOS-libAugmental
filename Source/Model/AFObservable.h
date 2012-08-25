//
//  AFObservable.h
//  iOS-libAugmental
//
//  Created by Chris Hatton on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFChangeFlag;

typedef struct observableEvent
{
    AFChangeFlag *changeFlag;
    NSArray      *parameters;
}
        observableEvent;

@interface AFObservable : NSObject
{
@private
    NSMutableSet *observers;
    NSMutableSet *events;
    uint32_t lockCount;
}

- (id)init;

- (void)notifyObservers:(AFChangeFlag *)changeFlag parameters:(NSObject *)objects, ...;

- (void)addObserver:(AFObservable *)observable;

- (void)removeObserver:(AFObservable *)observable;

- (void)beginAtomic;

- (void)completeAtomic;

@end
