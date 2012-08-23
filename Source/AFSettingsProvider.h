
#import <Foundation/Foundation.h>

//@class AFSettingsSection;
@protocol AFSetting;

@protocol AFSettingsProvider

-(NSArray*)settingsSections;
-(void)settingValueChanged:(NSObject<AFSetting>*)setting;

@end
