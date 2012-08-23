
@protocol AFSetting;

@protocol AFSettingObserver

-(void)settingChanged:(NSObject<AFSetting>*)setting;

@end
