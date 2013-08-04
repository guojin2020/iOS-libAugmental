//
// Created by Chris Hatton on 18/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFDefaultsBackedStringDictionary.h"
#import "AFMethodBlockedException.h"
#import "AFLog.h"

const NSString *AFDefaultsBackedDictionaryInvalidArgumentReason = @"You may only store NSString objects in an AFDefaultsBackedStringDictionary";

static NSUserDefaults *defaults;

@implementation AFDefaultsBackedStringDictionary
{
    NSString* defaultsKey;
    NSMutableDictionary* dictionary;
}

+(void)initialize
{
    defaults = [NSUserDefaults standardUserDefaults];
}

-(id)initWithDefaultsKey:(NSString*)defaultsKeyIn
{
    if ( self = [self init] )
    {
        defaultsKey = defaultsKeyIn;

        NSDictionary* storedDictionary = [defaults dictionaryForKey:defaultsKey];
        if(storedDictionary && [storedDictionary count]>0)
        {
            AFLog(@"Read %i entries from stored array '%@'",[storedDictionary count],defaultsKeyIn);
            dictionary = [[NSMutableDictionary alloc] initWithDictionary:storedDictionary];
        }
        else
        {
            dictionary = [[NSMutableDictionary alloc] init];
        }

        NSNotificationCenter* defaults = [NSNotificationCenter defaultCenter];
        SEL synchronizationSelector = @selector(synchronize);

        [defaults addObserver:self
                     selector:synchronizationSelector
                         name:UIApplicationWillTerminateNotification
                       object:NULL];

        [defaults addObserver:self
                     selector:synchronizationSelector
                         name:UIApplicationWillResignActiveNotification
                       object:NULL];
    }
    return self;
}

// Invalidate all other NSMutableDictionary initialisers, allowing only initWithDefaultsKey:

- (id)initWithCapacity:(NSUInteger)numItems                                                 { @throw([AFMethodBlockedException new]); }
- (id)initWithObjects:(id[])objects forKeys:(id <NSCopying>[])keys count:(NSUInteger)cnt    { @throw([AFMethodBlockedException new]); }
- (id)initWithObjectsAndKeys:(id)firstObject, ...                                           { @throw([AFMethodBlockedException new]); }
- (id)initWithDictionary:(NSDictionary *)otherDictionary                                    { @throw([AFMethodBlockedException new]); }
- (id)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag               { @throw([AFMethodBlockedException new]); }
- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys                            { @throw([AFMethodBlockedException new]); }
- (id)initWithContentsOfFile:(NSString *)path                                               { @throw([AFMethodBlockedException new]); }
- (id)initWithContentsOfURL:(NSURL *)url                                                    { @throw([AFMethodBlockedException new]); }

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
	@synchronized (dictionary)
	{
	    if(!([anObject isKindOfClass:[NSString class]] ||
			 [anObject isKindOfClass:[NSNumber class]]))
	        [NSException raise:NSInvalidArgumentException format:AFDefaultsBackedDictionaryInvalidArgumentReason];

	    dictionary[aKey] = anObject;
	}
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
	@synchronized(dictionary)
	{
		if(!([obj isKindOfClass:[NSString class]] ||
		     [obj isKindOfClass:[NSNumber class]]))
	        [NSException raise:NSInvalidArgumentException format:AFDefaultsBackedDictionaryInvalidArgumentReason];

		[dictionary setObject:obj forKeyedSubscript:key];
	}
}

- (id)objectForKey:(id)aKey
{
	@synchronized(dictionary)
	{
		return dictionary[aKey];
	}
}

- (NSUInteger)count
{
	@synchronized(dictionary)
	{
		return [dictionary count];
	}
}
- (NSEnumerator *)keyEnumerator
{
	@synchronized(dictionary)
	{
		return [dictionary keyEnumerator];
	}
}

- (void)removeObjectForKey:(id)aKey
{
	@synchronized(dictionary)
	{
		[dictionary removeObjectForKey:aKey];
	}
}

-(void)synchronize
{
	@synchronized (dictionary)
	{
	    [defaults setObject:dictionary forKey:defaultsKey];
	    [defaults synchronize];
	}
}

- (void)dealloc
{
    NSNotificationCenter*notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter removeObserver:self
                                  name:UIApplicationWillTerminateNotification
                                object:NULL];

    [notificationCenter removeObserver:self
                                  name:UIApplicationWillResignActiveNotification
                                object:NULL];

}

@end