//
// Created by Chris Hatton on 18/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFDefaultsBackedStringDictionary.h"
#import "AFMethodBlockedException.h"

const NSString *INVALID_ARGUMENT_REASON = @"You may only store NSString objects in an AFDefaultsBackedStringDictionary";

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
    if(![anObject isKindOfClass:[NSString class]])  [NSException raise:NSInvalidArgumentException format:(NSString *)INVALID_ARGUMENT_REASON];
    [super setObject:anObject forKey:aKey];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    if(![obj isKindOfClass:[NSString class]])       [NSException raise:NSInvalidArgumentException format:(NSString *)INVALID_ARGUMENT_REASON];
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