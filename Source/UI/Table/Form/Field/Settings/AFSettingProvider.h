#import <Foundation/Foundation.h>

//@class AFFormSection;
@protocol AFField;

@protocol AFSettingProvider

- (NSArray *)settingsSections;

- (void)settingValueChanged:(NSObject <AFField> *)setting;

@end
