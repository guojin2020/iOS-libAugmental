#import "AFSettingViewPanelController.h"
#import "AFSettingViewPanelObserver.h"

@implementation AFSettingViewPanelController

- (id)init
{
    if ((self = [super init]))
    {
        loadingView = nil;
        [self.observers = [[NSMutableSet alloc] initWithCapacity:2] release];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self.observers = [[NSMutableSet alloc] initWithCapacity:2] release];
    }
    return self;
}

- (id)initWithObserver:(NSObject <AFSettingViewPanelObserver> *)observerIn nibName:(NSString *)nibNameIn bundle:(NSBundle *)bundleIn
{
    if ((self = [self initWithNibName:nibNameIn bundle:bundleIn]))
    {
        [observers addObject:observerIn];
    }
    return self;
}

- (id)initWithObservers:(NSSet *)initialObservers nibName:(NSString *)nibNameIn bundle:(NSBundle *)bundleIn
{
    if ((self = [self initWithNibName:nibNameIn bundle:bundleIn]))
    {
        [observers addObjectsFromArray:[initialObservers allObjects]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!value && defaultValue) //&& value!=defaultValue) //The default selected object was already selected before picked loaded, just refresh the pickers selection
    {
        [self setValue:defaultValue];
    }
}

- (void)setDefaultValue:(NSObject <NSCoding> *)defaultSelectedObjectIn
{
    NSObject <NSCoding> *oldSelection = defaultValue;
    defaultValue = [defaultSelectedObjectIn retain];
    [oldSelection release];

    if (!value) self.value = defaultValue;
}

- (void)setValue:(NSObject <NSCoding> *)valueIn
{
    if (valueIn != value)
    {
        NSObject <NSCoding> *oldValue = value;
        value = [valueIn retain];
        [oldValue release];

        [self broadcastNewValueToObservers:value];
    }
}

- (void)addObserver:(NSObject <AFSettingViewPanelObserver> *)observerIn
{[observers addObject:observerIn];}

- (void)removeObserver:(NSObject <AFSettingViewPanelObserver> *)observerIn
{[observers removeObject:observerIn];}

- (void)broadcastNewValueToObservers:(NSObject *)newValue
{
    for (NSObject <AFSettingViewPanelObserver> *observer in observers)
    {[observer settingViewPanel:self valueChanged:newValue];}
}

- (void)dealloc
{
    [observers release];
    [defaultValue release];
    [value release];
    [value release];
    [defaultValue release];
    //[loadingLabel release];
    [loadingView release];
    [super dealloc];
}

@synthesize value, defaultValue, observers;
@synthesize loadingLabel, loadingView;

@end
