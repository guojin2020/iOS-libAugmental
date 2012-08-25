#import <Foundation/Foundation.h>
#import "AFViewPanelSetting.h"
#import "AFSetting.h"
#import "AFDatePickerViewController.h"
#import "AFThemeable.h"

#define THEME_KEY_DATE_ICON @"dateIcon"

@protocol AFSettingPersistenceDelegate;

@interface AFDateSetting : AFViewPanelSetting <AFSetting, AFThemeable>
{
    NSDateFormatter *dateFormatter;
}

- (id)initWithId:(NSString *)identityIn;

+ (UIImage *)dateIcon;

@end
