//
// Created by Chris Hatton on 05/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFCache.h"

@implementation AFCache
{
    CFMutableDictionaryRef cache;
    AFCache * nextCache;
}

@synthesize nextCache;

- (id)init
{
    self = [super init];
    if (self)
    {
        cache = CFDictionaryCreateMutable(NULL, 1,  &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(purgeCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }

    return self;
}

-(NSObject*)objectForKey:(NSObject *)key
{
    NSObject *object = CFDictionaryGetValue(cache, key);
    if(!object && nextCache) object = [nextCache objectForKey:key];
    return object;
}

-(void)setObject:(NSObject*)object forKey:(NSObject*)key
{
    CFDictionarySetValue(cache, key, object);
}

-(void)purgeCache
{
	NSUInteger size = CFDictionaryGetCount(cache);
	CFTypeRef *keysTypeRef = (CFTypeRef *) malloc( size * sizeof(CFTypeRef) );
	CFDictionaryGetKeysAndValues(cache, keysTypeRef, NULL);

    NSObject *object;
	CFTypeRef keyRef;
	int i=0;
    while( (keyRef = keysTypeRef[i++] ) )
    {
        object = CFDictionaryGetValue(cache, keyRef);
        if([object retainCount]==1)
        {
	        CFDictionaryRemoveValue(cache, keyRef);
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
	CFRelease(cache);
    [nextCache release];
    [super dealloc];
}

@end