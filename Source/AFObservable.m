//
//  AFObservable.m
//  iOS-libAugmental
//
//  Created by Chris Hatton on 22/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFObservable.h"

#import "AFPObserver.h"
#import "AFChangeFlag.h"

@implementation AFObservable

-(id)init
{
    if(self = [super init])
    {
        observers   = [[NSMutableSet alloc] init];
        events      = [[NSMutableSet alloc] init];
        lockCount   = 0;
        return self;
    }
    else return NULL;
}

-(void) notifyObservers:(AFChangeFlag*)changeFlag parameters:(id)firstParameter, ...
{
    NSMutableArray* parameters;

    if (firstParameter)
    {
        parameters = [[NSMutableArray alloc] init];

        va_list parameterList;
        [parameters addObject: firstParameter];
        va_start(parameterList, firstParameter);
        id eachParameter;
        while ((eachParameter = va_arg(parameterList, id)))
        {
            [parameters addObject: eachParameter];
        }
        va_end(parameterList);
    }
    else parameters = NULL;
    
    if(lockCount==0)
    {
        [self fireNotification:changeFlag parameters:parameters];
    }
    else
    {
        observableEvent* event = malloc(sizeof(observableEvent));
        (*event).changeFlag = changeFlag;
        (*event).parameters = parameters;
        
        [events addObject:[NSValue valueWithPointer:event]];
    }
    
    [parameters release];
}

-(void)fireNotification:(AFChangeFlag*) changeFlag parameters:(NSArray*)parameters
{
    for (id<AFPObserver> observer in observers)
    {
        [observer change:changeFlag wasFiredBySource:self withParameters:parameters];
    }
}

-(void)addObserver:(id<AFPObserver>)observer
{
    [observers addObject:observer];
}

-(void)removeObserver:(id<AFPObserver>)observer
{
    [observers removeObject:observer];
}

-(void)dealloc
{
    [observers release];
    [events release];
    [super dealloc];
}

-(void)beginAtomic { ++lockCount; }
-(void)completeAtomic
{
    if(lockCount==0)
    {
        @throw [NSException exceptionWithName:@"AtomicLockException" reason:@"Mismatched calls to beginAtomic/completeAtomic" userInfo:nil];
    }
    else
    {
        --lockCount;
        if(lockCount==0)
        {
            for (NSValue* eventValue in events)
            {
                observableEvent* event = [eventValue pointerValue];
                
                for(id<AFPObserver> observer in observers)
                {
                    [observer change:(*event).changeFlag wasFiredBySource:self withParameters:(*event).parameters];
                }
                
                free(event);
            }
            
            [events removeAllObjects];
        }
    }
}

@end
