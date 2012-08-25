#import <Foundation/Foundation.h>
#import "AFViewPanelSetting.h"
#import "AFSetting.h"
#import "AFThemeable.h"

@protocol AFSettingPersistenceDelegate;

#define THEME_KEY_DATE_ICON @"dateIcon"

@interface AFMMYYDateSetting : AFViewPanelSetting <AFSetting, AFThemeable>
{
}

- (id)initWithId:(NSString *)identityIn yearRange:(NSRange)rangeIn;

+ (UIImage *)dateIcon;

@end
