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
        observers = [[NSMutableSet alloc] init];
        events    = [[NSMutableSet alloc] init];
        lockCount = 0;
        return self;
    }
    else return NULL;
}

- (void)notifyObservers:(SEL)eventIn parameterArray:(NSArray*)parameters
{
    if (lockCount == 0)
    {
        [self fireNotification:eventIn parameters:parameters];
    }
    else
    {
        observableEvent *event = malloc((unsigned long)sizeof(observableEvent));
        (*event).eventIn = eventIn;
        (*event).parameters = parameters;

        [events addObject:[NSValue valueWithPointer:event]];
    }
}

- (void)notifyObservers:(SEL)eventIn parameters:(id)firstParameter, ...
{
    NSMutableArray *parameters;

    if (firstParameter)
    {
        parameters = [[NSMutableArray alloc] init];

        va_list parameterList;
        [parameters addObject:firstParameter];
        va_start(parameterList, firstParameter);
        id eachParameter;
        while ((eachParameter = va_arg(parameterList, id)))
        {
            [parameters addObject:eachParameter];
        }
        va_end(parameterList);
    }
    else parameters = NULL;

    [self notifyObservers:eventIn parameterArray:parameters];

    [parameters release];
}

- (void)fireNotification:(SEL)eventIn parameters:(NSArray *)parameters
{
    for (id observer in observers)
    {
        //[observer event:eventIn wasFiredBySource:self withParameters:parameters];

        if (eventIn && [observer respondsToSelector:eventIn])
        {
            NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[observer methodSignatureForSelector:eventIn]];

            int parameterCount = [parameters count];

            id arguments [ parameterCount ];

            for ( NSUInteger i = 0; i < parameterCount; i++ )
            {
                arguments[i] = [parameters objectAtIndex:i];
                [invocation setArgument:&arguments[i] atIndex:i + 2];
            }
            [invocation setSelector:eventIn];
            [invocation invokeWithTarget:observer];
        }
    }
}

- (void)addObserver:    (id)observer { [observers addObject:observer];    }

- (void)addObservers:(NSArray *)observersIn
{
    for(id observer in observersIn) [self addObserver:observer];
}

- (void)removeObserver: (id)observer { [observers removeObject:observer]; }

- (void)dealloc
{
    [observers release];
    [events release];
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
            for (NSValue *eventValue in events)
            {
                observableEvent *event = [eventValue pointerValue];

                [self fireNotification:event->eventIn parameters:event->parameters];

                free(event);
            }

            [events removeAllObjects];
        }
    }
}

@end
