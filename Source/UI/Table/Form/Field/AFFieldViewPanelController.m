#import "AFFieldViewPanelController.h"
#import "AFFieldViewPanelObserver.h"

@implementation AFFieldViewPanelController

- (id)init
{
    if ((self = [super init]))
    {
        loadingView = nil;
        observers = [[NSMutableSet alloc] initWithCapacity:2];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        observers = [[NSMutableSet alloc] initWithCapacity:2];
    }
    return self;
}

- (id)initWithObserver:(NSObject <AFFieldViewPanelObserver> *)observerIn nibName:(NSString *)nibNameIn bundle:(NSBundle *)bundleIn
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
    defaultValue = defaultSelectedObjectIn;

    if (!value) self.value = defaultValue;
}

- (void)setValue:(NSObject <NSCoding> *)valueIn
{
    if (valueIn != value)
    {
        NSObject <NSCoding> *oldValue = value;
        value = valueIn;

        [self broadcastNewValueToObservers:value];
    }
}

- (void)addObserver:(NSObject <AFFieldViewPanelObserver> *)observerIn
{[observers addObject:observerIn];}

- (void)removeObserver:(NSObject <AFFieldViewPanelObserver> *)observerIn
{[observers removeObject:observerIn];}

- (void)broadcastNewValueToObservers:(NSObject *)newValue
{
    for (NSObject <AFFieldViewPanelObserver> *observer in observers)
    {[observer settingViewPanel:self valueChanged:newValue];}
}


@synthesize value, defaultValue, observers;
@synthesize loadingLabel, loadingView;

@end
