
#import <Foundation/Foundation.h>
#import "AFBaseSetting.h"
#import "AFSetting.h"

@protocol AFSettingPersistenceDelegate;

@interface AFBooleanSetting : AFBaseSetting <AFSetting>
{
	UISwitch* valueSwitch;
}

@end
