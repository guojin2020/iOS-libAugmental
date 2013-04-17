//
//  AFObservable.m
//  iOS-libAugmental
//
//  Created by Chris Hatton on 22/07/2012.
//  Copyright (c) 2012 Chris Hatton. All rights reserved.
//

#import "AFObservable.h"

SEL
    AFObservableEventBeginAtomic,
    AFObservableEventCompleteAtomic;

@implementation AFObservable

+(void)initialize
{
    AFObservableEventBeginAtomic    = @selector(atomicChangeWillBegin:),
    AFObservableEventCompleteAtomic = @selector(atomicChangeDidComplete:);
}

- (id)init
{
    self = [super init];
    if (self)
    {
        observers       = [[NSMutableSet alloc] init];
        invocationQueue = [[NSMutableSet alloc] init];
        lockCount       = 0;
    }
    return self;
}

- (void)notifyObservers:(SEL)eventIn parameters:(id)firstParameter, ...
{
	NSAssert(eventIn,NSInvalidArgumentException);

	NSMutableArray *parameters;

	if (firstParameter)
	{
		parameters = [NSMutableArray new];

		va_list parameterList;
		[parameters addObject:firstParameter];
		va_start(parameterList, firstParameter);
		id parameter;
		while( (parameter = va_arg(parameterList, id)) )
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

- (void)notifyObservers:(SEL)eventIn parameterArray:(NSArray*)parameters
{
    NSAssert ( eventIn, NSInvalidArgumentException );

    NSMethodSignature *selectorMethodSignature;
    NSInvocation *invocation;
    int index;

    NSSet* observersSnapshot = [observers copy];
    for (id observer in observersSnapshot)
    {
	    NSLog(@"Observer: %@",observer);

        if ( [observer respondsToSelector:eventIn] && ( selectorMethodSignature = [observer methodSignatureForSelector:eventIn] ) )
        {
	        NSLog(@"Sending: %@", NSStringFromSelector(eventIn));

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

- (void)addObserver:(id)observer
{
    [observers addObject:observer];
}

- (void)addObservers:(NSArray *)observersIn
{
    for(id observer in observersIn) [self addObserver:observer];
}

- (void)removeObserver:(id)observer
{
    [observers removeObject:observer];
}

- (void)dealloc
{
    [observers release];
    [invocationQueue release];
    [super dealloc];
}

- (void)beginAtomic
{
    if (lockCount==0)
    {
        [self notifyObservers:AFObservableEventBeginAtomic parameters:self, NULL];
    }

    ++lockCount;
}

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

            [self notifyObservers:AFObservableEventCompleteAtomic parameters:self, NULL];
        }
    }
}

@end
