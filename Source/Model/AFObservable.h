//
//  AFObservable.h
//  iOS-libAugmental
//
//  Created by Chris Hatton on 22/07/2012.
//  Copyright (c) 2012 Chris Hatton. All rights reserved.
//

#import <Foundation/Foundation.h>

extern SEL
    AFObservableEventBeginAtomic,
    AFObservableEventCompleteAtomic;

@interface AFObservable : NSObject
{
    @private
    NSCountedSet *observers;
    NSMutableSet *invocationQueue;
    uint32_t lockCount;
}

- (id)init;

-(void)notifyObservers:(SEL)eventIn parameterArray:(NSArray *)parameters;
-(void)notifyObservers:(SEL)eventIn parameters:(NSObject *)objects, ...;

- (void)addObserver:(id)observer;
- (void)addObservers:(NSArray *)observers;
- (void)removeObserver:(id)observer;
- (void)beginAtomic;
- (void)completeAtomic;

@end
