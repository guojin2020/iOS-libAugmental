//
// Created by augmental on 18/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFDefaultsBackedStringDictionary.h"

const NSString
        *invalidInitialiserException = @"InvalidInitialiserException",
        *invalidInitialiserReason    = @"You must use initWithDefaultsKey: to initialize an AFDefaultsBackedStringDictionary",
        *invalidObjectException      = @"InvalidObject",
        *invalidObjectReason         = @"You may only store NSString objects in an AFDefaultsBackedStringDictionary";

static NSUserDefaults *defaults;

@implementation AFDefaultsBackedStringDictionary
{
    NSString* defaultsKey;
}

+(void)initialize
{
    defaults = [NSUserDefaults standardUserDefaults];
}

-(id)initWithDefaultsKey:(NSString*)defaultsKeyIn
{
    NSDictionary *dictionary = [defaults dictionaryForKey:defaultsKeyIn];
    if ( dictionary && (self = [super initWithDictionary:dictionary]) )
    {
        defaultsKey = [defaultsKeyIn retain];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(synchronize)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:NULL];
    }
    return self;
}

// Invalidate all other NSMutableDictionary initialisers, allowing only initWithDefaultsKey:

- (id)initWithCapacity:(NSUInteger)numItems
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithObjects:(id[])objects forKeys:(id <NSCopying>[])keys count:(NSUInteger)cnt
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithObjectsAndKeys:(id)firstObject, ...
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithDictionary:(NSDictionary *)otherDictionary
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithContentsOfFile:(NSString *)path
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (id)initWithContentsOfURL:(NSURL *)url
{ @throw([NSException exceptionWithName:invalidInitialiserException reason:invalidInitialiserReason userInfo:NULL]); }

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(![anObject isKindOfClass:[NSString class]]) @throw([NSException exceptionWithName:invalidObjectException reason:invalidObjectReason userInfo:NULL]);
    [super setObject:anObject forKey:aKey];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    if(![obj isKindOfClass:[NSString class]]) @throw([NSException exceptionWithName:invalidObjectException reason:invalidObjectReason userInfo:NULL]);
    [super setObject:obj forKeyedSubscript:key];
}

-(void)synchronize
{
    [defaults setObject:self forKey:defaultsKey];
    [defaults synchronize];
}

- (void)dealloc
{
    [defaultsKey release];
    [super dealloc];
}

@end