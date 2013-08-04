#import "AFUserDefaultsSettingPersistence.h"

//#import "AFAppDelegate.h"

static AFUserDefaultsSettingPersistence *defaultCache = nil;

@implementation AFUserDefaultsSettingPersistence

+ (AFUserDefaultsSettingPersistence *)sharedInstance
{
    if (!defaultCache) defaultCache = [[AFUserDefaultsSettingPersistence alloc] init];
    return defaultCache;
}

- (void)persistFieldValue:(NSData *)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]; //([AFSession sharedSession]?[NSString stringWithFormat:@"%@.%@",[AFSession sharedSession].username,key]:
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSData *)restoreSettingValueForKey:(NSString *)key
{
    return (NSData *) [[NSUserDefaults standardUserDefaults] valueForKey:key];
}


@end
