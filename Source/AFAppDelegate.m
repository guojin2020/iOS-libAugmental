
#import "AFAppDelegate.h"
#import "AFScreenManager.h"
#import "AFFormSection.h"
#import "AFJSONRequest.h"
#import "AFBooleanField.h"
#import "AFCachingAudioPlayer.h"
#import "AFObjectCache.h"
#import "AFSession.h"
#import "AFLog.h"

static NSMutableDictionary* settings         = nil;
static AFBooleanField*      soundFXSetting   = nil;
static AFObservable*        appEventManager  = nil;

static BOOL
		globalSFXEnabled = NO,
		settingsLoaded   = NO;

SEL
    AFEventAppSettingsLoaded,
    AFEventAppTerminating,
    AFEventAppSettingsLoadFailed,
    AFEventAppMemoryWarning;

@implementation AFAppDelegate

+(void)load
{
    AFEventAppSettingsLoaded        = @selector(handleAppSettingsLoaded);
    AFEventAppTerminating           = @selector(handleAppTerminating);
    AFEventAppSettingsLoadFailed    = @selector(handleAppSettingsLoadFailed);
    AFEventAppMemoryWarning         = @selector(handleAppMemoryWarning);
}

+(AFObservable*)appEventManager
{
	if(!appEventManager) appEventManager = [[AFObservable alloc] init];
	return appEventManager;
}

-(BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	#ifdef CREATE_THEME_TEMPLATE_MODE
	//AFLog(@"RUNNING IN THEME-TEMPLATE CREATION MODE");
	
	//AFLog(@"Constructing theme-template from themeable classes...");
	NSDictionary* templateDictionary = [AFThemeManager generateThemeTemplate];

	//Get app document path
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [documentPaths objectAtIndex:0];

	//Make temp file path
	NSString *tempFilePath = [NSString stringWithFormat:@"%@temp.plist",documentsDirectory];

	//Write array to file
	//AFLog(@"Saving to: %@",tempFilePath);
	[templateDictionary writeToFile:tempFilePath atomically:NO];
	
	//Read back file
	NSString *plistData = [NSString stringWithContentsOfFile:tempFilePath encoding:NSUTF8StringEncoding AFSessionStateError:nil];
	
	//Dump file contents
	//AFLog(@"\n---- TEMPLATE PLIST START ----\n\n%@\n\n---- TEMPLATE PLIST END ----",plistData);
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

-(void)settingValueChanged:(AFField*)setting {}

+(NSString*)settingsPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+(int)deviceId{return 1;}

-(void)applicationWillTerminate:(UIApplication*)application
{
    [[AFAppDelegate appEventManager] notifyObservers:AFEventAppTerminating parameters:NULL];
}

-(void)request:(AFRequest*)request returnedWithData:(id)data
{
	NSAssert(request==settingsRequest,@"AFAppDelegate received a response from an unexpected request: %@",request);
	
	NSDictionary* settings = (NSDictionary*)[(NSDictionary*)data objectForKey:@"settings"];
	if(settings)
	{
		[[AFAppDelegate settings] addEntriesFromDictionary:settings];
        [[AFAppDelegate appEventManager] notifyObservers:AFEventAppSettingsLoaded parameters:NULL];
		settingsLoaded=YES;
	}
	else
	{
        [[AFAppDelegate appEventManager] notifyObservers:AFEventAppSettingsLoadFailed parameters:NULL];
	}
}

- (void)requestFailed:(AFRequest *)request withError:(NSError*)error
{
    AFLogPosition();
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
    [[AFAppDelegate appEventManager] notifyObservers:AFEventAppMemoryWarning parameters:NULL];
}

-(NSArray*)settingsSections
{
    return nil;
}


@end
