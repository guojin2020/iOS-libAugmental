#import "AFFieldDrivenObjectPickerViewController.h"
#import "AFObjectRequest.h"
#import "AFObjectHelper.h"
#import "AFAppDelegate.h"
#import "AFSession.h"
#import "AFObjectCache.h"
#import "AFEnvironment.h"
#import "AFLog.h"

@interface AFFieldDrivenObjectPickerViewController ()

- (void)setupUsingSettings;

@end

@implementation AFFieldDrivenObjectPickerViewController

- (id)  initWithTitle:(NSString *)titleIn
     getObjectActionString:(NSString *)getObjectActionStringIn
 objectCSVIdListSettingsKey:(NSString *)objectCSVIdListSettingsKeyIn
objectDefaultSelectionIdKey:(NSString *)objectDefaultSelectionIdKeyIn
                objectClass:(Class)objectClassIn
{
    if ((self = [super initWithObjects:nil delegate:self title:titleIn]))
    {
        getObjectActionString       = getObjectActionStringIn;
        objectCSVIdListSettingsKey  = objectCSVIdListSettingsKeyIn;
        objectDefaultSelectionIdKey = objectDefaultSelectionIdKeyIn;
        objectClass                 = objectClassIn;

        if ([AFAppDelegate settingsLoaded])
        {
            [self setupUsingSettings];
        }
        else
        {
            [[AFAppDelegate appEventManager] addObserver:self];
        }
    }
    return self;
}

- (void)setupUsingSettings
{
    NSString        *csvIdList      = [[AFAppDelegate settings] valueForKey:objectCSVIdListSettingsKey];
    NSURL           *objectsURL     = [NSURL URLWithString:[NSString stringWithFormat:@"?action=%@&idList=%@", getObjectActionString, csvIdList] relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
    AFObjectRequest *objectsRequest = [[AFObjectRequest alloc] initWithURL:objectsURL endpoint:self];
    [[AFSession sharedSession] handleRequest:objectsRequest];
}

- (void)request:(AFRequest*)request returnedWithData:(id)objectsIn
{
    objects = [[NSMutableArray alloc] initWithArray:objectsIn];
    [picker reloadAllComponents];

    int defaultObjectPk = [[AFObjectHelper numberFromString:[[AFAppDelegate settings] valueForKey:objectDefaultSelectionIdKey]] intValue];
    NSObject <NSCoding> *defaultObject = [[AFSession sharedSession].cache objectOfType:objectClass withPrimaryKey:defaultObjectPk];
    [self setDefaultValue:defaultObject];

    //[loadingView removeFromSuperview];
}

- (void)requestFailed:(AFRequest *)request
            withError:(NSError *)error
{
}

-(void)handleAppSettingsLoaded
{
    AFLogPosition();

    [self setupUsingSettings];
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

- (void)settingViewPanel:(AFFieldViewPanelController *)viewPanelController valueChanged:(NSObject *)newValue
{
}


@end
