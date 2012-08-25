#import <Foundation/Foundation.h>
#import "AFSettingPersistenceDelegate.h"

@class AFSession;

@interface AFUserDefaultsSettingPersistence : NSObject <AFSettingPersistenceDelegate>
{
    NSUserDefaults *defaults;
}

+ (AFUserDefaultsSettingPersistence *)sharedInstance;

@end
