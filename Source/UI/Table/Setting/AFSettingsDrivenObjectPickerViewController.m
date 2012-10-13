#import "AFSettingsDrivenObjectPickerViewController.h"
#import "AFObjectRequest.h"
#import "AFObjectHelper.h"
#import "AFAppDelegate.h"
#import "AFSession.h"
#import "AFObjectCache.h"
#import "AFEnvironment.h"
#import "AFEventManager.h"

@interface AFSettingsDrivenObjectPickerViewController ()

- (void)setupUsingSettings;

@end

@implementation AFSettingsDrivenObjectPickerViewController

- (id)  initWithTitle:(NSString *)titleIn
     getObjectActionString:(NSString *)getObjectActionStringIn
 objectCSVIdListSettingsKey:(NSString *)objectCSVIdListSettingsKeyIn
objectDefaultSelectionIdKey:(NSString *)objectDefaultSelectionIdKeyIn
                objectClass:(id<AFObject>)objectClassIn
{
    if ((self = [super initWithObjects:nil delegate:self title:titleIn]))
    {
        getObjectActionString       = [getObjectActionStringIn retain];
        objectCSVIdListSettingsKey  = [objectCSVIdListSettingsKeyIn retain];
        objectDefaultSelectionIdKey = [objectDefaultSelectionIdKeyIn retain];
        objectClass                 = objectClassIn;

        if ([AFAppDelegate settingsLoaded])
        {
            [self setupUsingSettings];
        }
        else
        {
            [[AFAppDelegate appEventManager] addObserver:self];
        }

        //loadingView = [[NSBundle mainBundle] loadNibNamed:@"AFScreenLoadingView" owner:self options:nil];
    }
    return self;
}

- (void)setupUsingSettings
{
    NSString        *csvIdList      = [[AFAppDelegate settings] valueForKey:objectCSVIdListSettingsKey];
    NSURL           *objectsURL     = [NSURL URLWithString:[NSString stringWithFormat:@"?action=%@&idList=%@", getObjectActionString, csvIdList] relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
    AFObjectRequest *objectsRequest = [[AFObjectRequest alloc] initWithURL:objectsURL endpoint:self];
    [[AFSession sharedSession] handleRequest:objectsRequest];
    [objectsRequest release];
}

- (void)request:(NSObject <AFRequest> *)request returnedWithData:(id)objectsIn
{
    objects = [[NSMutableArray alloc] initWithArray:objectsIn];
    [picker reloadAllComponents];

    int defaultObjectPk = [[AFObjectHelper numberFromString:[[AFAppDelegate settings] valueForKey:objectDefaultSelectionIdKey]] intValue];
    NSObject <NSCoding> *defaultObject = [[AFSession sharedSession].cache objectOfType:objectClass withPrimaryKey:defaultObjectPk];
    [self setDefaultValue:defaultObject];

    //[loadingView removeFromSuperview];
}

- (void)eventOccurred:(event)type source:(NSObject *)source
{
    if (type == APP_SETTINGS_LOADED)
    {
        [self setupUsingSettings];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    adviceText.text = @"Please use the picker above to select a shipping method for your order.";
}

- (NSString *)titleForObject:(NSObject *)object
{
    return [NSString stringWithFormat:@"%@", object];
}

- (void)settingViewPanel:(AFSettingViewPanelController *)viewPanelController valueChanged:(NSObject *)newValue
{
}

- (void)dealloc
{
    [getObjectActionString release];
    [objectCSVIdListSettingsKey release];
    [objectDefaultSelectionIdKey release];
    [super dealloc];
}

@end
