//
// Created by Chris Hatton on 18/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFDefaultsBackedStringArray.h"

const NSString *AFDefaultsBackedArrayInvalidArgumentReason = @"You may only store NSString objects in an AFDefaultsBackedStringDictionary";

static NSUserDefaults *defaults;

@implementation AFDefaultsBackedStringArray
{
    NSString* defaultsKey;
    NSMutableArray*array;
}

+(void)initialize
{
    defaults = [NSUserDefaults standardUserDefaults];
}

-(id)initWithDefaultsKey:(NSString*)defaultsKeyIn
{
    if ( self = [self init] )
    {
        defaultsKey = [defaultsKeyIn retain];

        NSArray* storedArray = [defaults arrayForKey:defaultsKey];
        if(storedArray && [storedArray count]>0)
        {
            NSLog(@"Read %i entries from stored array '%@'",[storedArray count],defaultsKeyIn);
            array = [[NSMutableArray alloc] initWithArray:storedArray];
        }
        else
        {
            array = [[NSMutableArray alloc] init];
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

- (void)addObject:(id)anObject
{
    if(![anObject isKindOfClass:[NSString class]]) [NSException raise:NSInvalidArgumentException format:AFDefaultsBackedArrayInvalidArgumentReason];
    [array addObject:anObject];
}

- (BOOL)containsObject:(id)anObject
{
    return [array containsObject:anObject];
}

-(void)synchronize
{
    [defaults setObject:array forKey:defaultsKey];
    [defaults synchronize];
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

    [array release];
    [defaultsKey release];
    [super dealloc];
}

@end