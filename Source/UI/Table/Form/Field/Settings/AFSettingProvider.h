#import <Foundation/Foundation.h>

//@class AFFormSection;
@class AFField;

@protocol AFSettingProvider

- (NSArray *)settingsSections;

- (void)settingValueChanged:(AFField*)setting;

@end
