
#import <UIKit/UIKit.h>
#import "AFRequestEndpoint.h"
#import "AFSettingProvider.h"

//#define CREATE_THEME_TEMPLATE_MODE

@class AFEventManager;
@class AFJSONRequest;
@class AFBooleanField;
//@class AFSettingsScreen;

@protocol AFEventObserver;

@interface AFAppDelegate : UIResponder <UIApplicationDelegate, AFRequestEndpoint, AFSettingProvider>
{
    UIWindow*           window;
	AFJSONRequest*      settingsRequest;
	NSArray*            settingsSections;
	//AFSettingsScreen*   settingsScreen;
}

+(AFEventManager*) appEventManager;
+(NSString*)settingsPath;
+(NSMutableDictionary*)settings;
+(int)deviceId;
+(BOOL)soundsEnabled;
+(void)playSound:(NSString*)name;
+(void)setGlobalSFXEnable:(BOOL)globalSFXEnabledIn;

+(BOOL)settingsLoaded;

@end

