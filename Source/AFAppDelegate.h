
#import <UIKit/UIKit.h>
#import "AFRequestEndpoint.h"
#import "AFSettingProvider.h"

//#define CREATE_THEME_TEMPLATE_MODE

extern SEL
    AFEventAppSettingsLoaded,
    AFEventAppTerminating,
    AFEventAppSettingsLoadFailed,
    AFEventAppMemoryWarning;

@class AFJSONRequest;
@class AFBooleanField;
@class AFObservable;

@interface AFAppDelegate : UIResponder <UIApplicationDelegate, AFRequestEndpoint, AFSettingProvider>
{
    UIWindow*           window;
	AFJSONRequest*      settingsRequest;
	NSArray*            settingsSections;
}

+(AFObservable*) appEventManager;
+(NSString*)settingsPath;
+(NSMutableDictionary*)settings;
+(int)deviceId;
+(BOOL)soundsEnabled;
+(void)playSound:(NSString*)name;
+(void)setGlobalSFXEnable:(BOOL)globalSFXEnabledIn;

+(BOOL)settingsLoaded;

@end

