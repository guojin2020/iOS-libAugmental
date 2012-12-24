//
//  AFObservable.m
//  iOS-libAugmental
//
//  Created by Chris Hatton on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFObservable.h"

@implementation AFObservable

- (id)init
{
    if (self = [super init])
    {
        observers       = [[NSMutableSet alloc] init];
        invocationQueue = [[NSMutableSet alloc] init];
        lockCount = 0;
        return self;
    }
    else return NULL;
}

- (void)notifyObservers:(SEL)eventIn parameterArray:(NSArray*)parameters
{
    NSAssert ( eventIn, NSInvalidArgumentException );

    NSMethodSignature *selectorMethodSignature;
    NSInvocation *invocation;
    int index;

    NSSet* observersSnapshot = [[NSSet alloc] initWithSet:observers];
    for (id observer in observersSnapshot)
    {
        if ( [observer respondsToSelector:eventIn] && ( selectorMethodSignature = [observer methodSignatureForSelector:eventIn] ) )
        {
            invocation = [NSInvocation invocationWithMethodSignature:selectorMethodSignature];
            invocation.target = observer;
            invocation.selector = eventIn;

            index = 2; // Indices 0, 1 are reserved according to NSInvocation documentation
            for (id parameter in parameters)
            {
                [invocation setArgument:&parameter atIndex:index++];
            }

            if (lockCount == 0)
            {
                [invocation invoke];
            }
            else
            {
                [invocationQueue addObject:invocation];
            }
        }
    }
    [observersSnapshot release];
}

- (void)notifyObservers:(SEL)eventIn parameters:(id)firstParameter, ...
{
    NSAssert(eventIn,NSInvalidArgumentException);

    NSMutableArray *parameters;

    if (firstParameter)
    {
        parameters = [[NSMutableArray alloc] init];

        int index=0;
        va_list parameterList;
        [parameters addObject:firstParameter];
        va_start(parameterList, firstParameter);
        id parameter;
        while ((parameter = va_arg(parameterList, id)))
        {
            [parameters addObject:parameter];
        }
        va_end(parameterList);
    }
    else
    {
        parameters = NULL;
    }

    [self notifyObservers:eventIn parameterArray:parameters];

    [parameters release];
}


- (void)addObserver:    (id)observer { [observers addObject:observer];    }

- (void)addObservers:(NSArray *)observersIn
{
    for(id observer in observersIn) [self addObserver:observer];
}

- (void)removeObserver: (id)observer
{
    [observers removeObject:observer];
}

- (void)dealloc
{
    [observers release];
    [invocationQueue release];
    [super dealloc];
}

- (void)beginAtomic { ++lockCount; }

- (void)completeAtomic
{
    if (lockCount == 0)
    {
        @throw [NSException exceptionWithName:@"AtomicLockException" reason:@"Mismatched calls to beginAtomic/completeAtomic" userInfo:nil];
    }
    else
    {
        --lockCount;
        if (lockCount == 0)
        {
            for (NSInvocation *invocation in invocationQueue)
            {
                [invocation invoke];
            }

            [invocationQueue removeAllObjects];
        }
    }
}

@end
