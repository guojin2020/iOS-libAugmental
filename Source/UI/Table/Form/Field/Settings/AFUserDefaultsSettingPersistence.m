#import "AFUserDefaultsSettingPersistence.h"

//#import "AFAppDelegate.h"

static AFUserDefaultsSettingPersistence *sharedInstance = nil;

@implementation AFUserDefaultsSettingPersistence

+ (AFUserDefaultsSettingPersistence *)sharedInstance
{
    if (!sharedInstance) sharedInstance = [[AFUserDefaultsSettingPersistence alloc] init];
    return sharedInstance;
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

- (void)dealloc
{

    [defaults release];
    [super dealloc];
}

@end
