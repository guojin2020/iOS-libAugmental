
#import <UIKit/UIKit.h>
#import "AFRequestEndpoint.h"
#import "AFSettingsProvider.h"

//#define CREATE_THEME_TEMPLATE_MODE

@class AFEventManager;
@class AFJSONRequest;
@class AFBooleanSetting;
@class AFSettingsScreen;

@protocol AFEventObserver;

@interface AFAppDelegate : UIResponder <UIApplicationDelegate, AFRequestEndpoint, AFSettingsProvider>
{
    UIWindow* window;
	AFJSONRequest* settingsRequest;
	NSArray* settingsSections;
	AFSettingsScreen* settingsScreen;
    //UIViewController* rootViewController;
}

/*
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
*/

+(AFEventManager*) appEventManager;
+(NSString*)settingsPath;
+(NSMutableDictionary*)settings;
+(int)deviceId;
+(BOOL)soundsEnabled;
+(void)playSound:(NSString*)name;
+(void)setGlobalSFXEnable:(BOOL)globalSFXEnabledIn;

+(BOOL)settingsLoaded;

//+(UIViewController*)rootViewController;

//@property (nonatomic, retain) UIViewController* rootViewController;

@end

