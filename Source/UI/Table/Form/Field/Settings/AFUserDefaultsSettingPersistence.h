#import <Foundation/Foundation.h>
#import "AFFieldPersistenceDelegate.h"

@class AFSession;

@interface AFUserDefaultsSettingPersistence : NSObject <AFFieldPersistenceDelegate>
{
    NSUserDefaults *defaults;
}

+ (AFUserDefaultsSettingPersistence *)sharedInstance;

@end
