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
        observers       = [NSCountedSet new];
        invocationQueue = [NSMutableSet new];
        lockCount       = 0;
    }
    return self;
}

- (void)notifyObservers:(SEL)eventIn parameters:(id)firstParameter, ...
{
	NSAssert(eventIn,NSInvalidArgumentException);

	NSMutableArray *parameters;

	if( firstParameter )
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

}

- (void)notifyObservers:(SEL)eventIn parameterArray:(NSArray*)parameters
{
    NSAssert ( eventIn, NSInvalidArgumentException );

	@synchronized (observers)
	{
	    NSMethodSignature *selectorMethodSignature;
	    NSInvocation *invocation;
	    int index;

	    NSSet* observersSnapshot = [observers copy];

	#if LOG_OBSERVERS
		AFLog(@"%@ -> ", NSStringFromSelector(eventIn) );
		for (id observer in observersSnapshot)
		{
			BOOL ok = [observer respondsToSelector:eventIn] && ( selectorMethodSignature = [observer methodSignatureForSelector:eventIn]);
			AFLog(@"- %@, %@",observer, ok?@"Yes":@"No" );
		}
	#endif

	    for (id observer in observersSnapshot)
	    {
	        if ( [observer respondsToSelector:eventIn] && ( selectorMethodSignature = [observer methodSignatureForSelector:eventIn] ) )
	        {
	            invocation = [NSInvocation invocationWithMethodSignature:selectorMethodSignature];
	            invocation.target = observer;
	            invocation.selector = eventIn;

	            index = 2; // Indices 0, 1 are reserved according to NSInvocation documentation
	            for (__unsafe_unretained id parameter in parameters)
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
	}
}

- (void)addObserver:(id)observer
{
	@synchronized (observers)
	{
		[observers addObject:observer];
	}
}

- (void)addObservers:(NSArray *)observersIn
{
    for(id observer in observersIn) [self addObserver:observer];
}

- (void)removeObserver:(id)observer
{
	@synchronized (observers)
	{
        [observers removeObject:observer];
	}
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
