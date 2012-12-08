
#import "AFAppDelegate.h"
#import "AFEventObserver.h"
#import "AFScreenManager.h"
#import "AFFormSection.h"
#import "AFJSONRequest.h"
#import "AFBooleanField.h"
#import "AFCachingAudioPlayer.h"
#import "AFObjectCache.h"
#import "AFEventManager.h"
#import "AFSession.h"

static NSMutableDictionary* settings = nil;
static BOOL settingsLoaded = NO;
static AFEventManager* appEventManager = nil;
static AFBooleanField * soundFXSetting = nil;
static BOOL globalSFXEnabled = NO;

@implementation AFAppDelegate

+(AFEventManager*)appEventManager
{
	if(!appEventManager) appEventManager = [[AFEventManager alloc] init];
	return appEventManager;
}

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	#ifdef CREATE_THEME_TEMPLATE_MODE
	//NSLog(@"RUNNING IN THEME-TEMPLATE CREATION MODE");
	
	//NSLog(@"Constructing theme-template from themeable classes...");
	NSDictionary* templateDictionary = [AFThemeManager generateThemeTemplate];

	//Get app document path
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [documentPaths objectAtIndex:0];

	//Make temp file path
	NSString *tempFilePath = [NSString stringWithFormat:@"%@temp.plist",documentsDirectory];

	//Write dictionary to file
	//NSLog(@"Saving to: %@",tempFilePath);
	[templateDictionary writeToFile:tempFilePath atomically:NO];
	
	//Read back file
	NSString *plistData = [NSString stringWithContentsOfFile:tempFilePath encoding:NSUTF8StringEncoding AFSessionStateError:nil];
	
	//Dump file contents
	//NSLog(@"\n---- TEMPLATE PLIST START ----\n\n%@\n\n---- TEMPLATE PLIST END ----",plistData);
	#else

	globalSFXEnabled = NO;
	
	application.statusBarStyle = UIStatusBarStyleBlackOpaque;
		
	NSDictionary *savedSettings = (NSDictionary*)[[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
	if(savedSettings)[settings addEntriesFromDictionary:savedSettings];
	
	//Disable in-built caching (and the memory management problems that come with it!)
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
		
	globalSFXEnabled=YES;
	
	[[AFSession sharedSession].cache pruneCache];
	
	#endif
	
	return YES;
}

-(void)settingValueChanged:(NSObject<AFField>*)setting {}

+(NSString*)settingsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(int)deviceId{return 1;}

-(void)applicationWillTerminate:(UIApplication*)application
{
    [[AFAppDelegate appEventManager] broadcastEvent:(AFAppEvent) AFEventAppTerminating source:self];
}

-(void)request:(NSObject<AFRequest>*)request returnedWithData:(id)data
{
	NSAssert(request==settingsRequest,@"AFAppDelegate received a response from an unexpected request: %@",request);
	
	NSDictionary* settings = (NSDictionary*)[(NSDictionary*)data objectForKey:@"settings"];
	if(settings)
	{
		[[AFAppDelegate settings] addEntriesFromDictionary:settings];
        [[AFAppDelegate appEventManager] broadcastEvent:(AFAppEvent) AFEventAppSettingsLoaded source:self];
		settingsLoaded=YES;
	}
	else
	{
        [[AFAppDelegate appEventManager] broadcastEvent:(AFAppEvent) AFEventAppSettingsLoadFailed source:self];
	}
	[settingsRequest release];
}

+(BOOL)settingsLoaded{return settingsLoaded;}

+(BOOL)soundsEnabled
{
	return (globalSFXEnabled && [(NSNumber*)soundFXSetting.value boolValue]);
}

+(void)playSound:(NSString*)name
{
	if([AFAppDelegate soundsEnabled])[AFCachingAudioPlayer playSound:name];
}

+(void)setGlobalSFXEnable:(BOOL)globalSFXEnabledIn
{
	globalSFXEnabled = globalSFXEnabledIn;
}

+(NSMutableDictionary*)settings
{
	if(!settings) settings = [[NSMutableDictionary alloc] init];
	return settings;
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[AFAppDelegate appEventManager] broadcastEvent:(AFAppEvent) AFEventAppMemoryWarning source:self];
}

-(NSArray*)settingsSections
{
    return nil;
}

-(void)dealloc
{
	[window release];
	[super dealloc];
}
/*
+(UIViewController*)rootViewController
{
    return ((AFAppDelegate*)([UIApplication sharedApplication].delegate)).rootViewController;
}

@synthesize rootViewController;
*/
@end
