#import "AFScreen.h"
#import "AFSession.h"
#import "AFScreenObserver.h"
#import "AFThemeManager.h"

static UIColor  *bgColor;
static NSNumber *bgOpacity;
static NSString *loadingTitle;
static UIColor  *loadingTitleColor;

@interface AFScreen ()

- (void)viewControllerBackgroundInitWrapInternal;

@end

@implementation AFScreen

- (id)initNeedingNavigationController:(BOOL)needsNavigationControllerIn
{
    if ((self = [super init]))
    {
        needsNavigationController = needsNavigationControllerIn;

        viewController   = nil;
        settingsSections = nil;
        active           = NO;
        needsInit        = YES;

        self.tabName = [self defaultTabName];
        [[AFSession sharedSession] addObserver:self];

        observers = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)loadViewController
{
    UIViewController *defaultViewController = [[UIViewController alloc] init];
    self.viewController       = defaultViewController;
    self.viewController.title = [self defaultTabName];
    [defaultViewController release];
}

- (void)setViewController:(UIViewController *)viewControllerIn
{
    UIViewController *oldViewController = viewController;
    viewController = [viewControllerIn retain];

    for (NSObject <AFScreenObserver> *observer in observers)
    {
        if ([observer respondsToSelector:@selector(screenViewControllerChanged:from:)])[observer screenViewControllerChanged:self from:oldViewController];
    }

    //Default ViewController initialisation
    viewController.navigationItem.backBarButtonItem.title = self.defaultTabName;

    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:self.tabName image:self.tabBarIcon tag:0];
    viewController.tabBarItem = item;
    [item release];

    [oldViewController release];
}

- (void)viewControllerBackgroundInitWrapInternal
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self viewControllerBackgroundInit];
    [pool release];
}

- (void)viewControllerBackgroundInit
{
    //Should be overridden by subclasses to provide full initialisation
}

- (void)viewControllerDidLoad //Clear "Loading..." subview
{
    [loadingView removeFromSuperview];
}

- (UIViewController *)viewController
{
    if (!viewController)
    {
        [self loadViewController];
        //[[NSBundle mainBundle] loadNibNamed:@"AFScreenLoadingView" owner:self options:nil];

        UIColor *bgColor = [AFScreen bgColor];
        bgColor = [UIColor colorWithRed:[bgColor red] green:[bgColor green] blue:[bgColor blue] alpha:[AFScreen bgOpacity]];

        [loadingView setBackgroundColor:bgColor];
        [loadingLabel setText:[AFScreen loadingTitle]];
        [loadingLabel setTextColor:[AFScreen loadingTitleColor]];
    }
    return viewController;
}

- (BOOL)viewControllerIsLoaded
{return viewController != nil;}

- (void)viewControllerWillAppear:(BOOL)animated
{
    if (needsInit)
    {
        needsInit = NO;

        if (![self viewControllerIsLoaded])[self loadViewController];

        //Often larger than necessary but fine for a top-aligned loading screen
        //CGSize size = [UIScreen mainScreen].applicationFrame.size;
        loadingView.autoresizesSubviews = YES;

        [viewController.view addSubview:loadingView];

        //loadingView.frame = viewController.view.frame;

        CGSize size = viewController.view.frame.size;
        loadingView.frame  = CGRectMake(0, 0, size.width, size.height);
        loadingView.bounds = CGRectMake(0, 0, size.width, size.height);

        [self performSelectorInBackground:@selector(viewControllerBackgroundInitWrapInternal) withObject:nil];
    }
}

- (UIImage *)tabBarIcon
{return [[self class] performSelector:@selector(defaultTabBarIcon)];}

- (NSArray *)settingsSections
{return nil;}

- (void)settingValueChanged:(NSObject <AFSetting> *)setting
{[self doesNotRecognizeSelector:_cmd];}

- (void)refreshActive
{[self doesNotRecognizeSelector:_cmd];}

- (BOOL)active
{return active;}

- (void)setActive:(BOOL)nowActive
{
    if (active != nowActive)
    {
        active = nowActive;

        NSSet                            *observerSnapshot = [[NSSet alloc] initWithSet:observers];
        for (NSObject <AFScreenObserver> *observer in observerSnapshot)
        {
            if (active)[observer screenBecameActive:self];
            else [observer screenBecameInactive:self];
        }
        [observerSnapshot release];
    }
}

- (void)addScreenObserver:(NSObject <AFScreenObserver> *)observer
{[observers addObject:observer];}

- (void)removeScreenObserver:(NSObject <AFScreenObserver> *)observer
{[observers removeObject:observer];}

- (void)stateOfSession:(AFSession *)changedSession changedFrom:(AFSessionState)oldState to:(AFSessionState)newState
{}

- (void)session:(AFSession *)changedSession becameOffline:(BOOL)offlineState
{}

- (UINavigationController *)navigationController
{return viewController.navigationController;}

- (void)setViewController:(UIViewController *)viewControllerIn animated:(BOOL)animatedIn
{
    [self setViewController:viewControllerIn];
}

- (UIImage *)defaultTabBarIcon
{return [[self class] performSelector:@selector(defaultTabBarIcon)];}

- (NSString *)defaultTitle
{return [[self class] performSelector:@selector(defaultTitle)];}

- (NSString *)defaultTabName
{return [[self class] performSelector:@selector(defaultTabName)];}

+ (UIImage *)defaultTabBarIcon
{return nil;}

+ (NSString *)defaultTitle
{return @"Untitled";}

+ (NSString *)defaultTabName
{return @"Untitled";}

//==============>> Theme Getters

+ (UIColor *)bgColor
{
    if (!bgColor)
    {bgColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFScreen class]] colorForKey:THEME_KEY_LOADING_BG_COLOR] retain];}
    return bgColor;
}

+ (float)bgOpacity
{
    if (!bgOpacity)
    {bgOpacity = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFScreen class]] objectForKey:THEME_KEY_LOADING_BG_OPACITY] retain];}
    return [bgOpacity floatValue];
}

+ (NSString *)loadingTitle
{
    if (!loadingTitle)
    {loadingTitle = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFScreen class]] valueForKey:THEME_KEY_LOADING_TITLE] retain];}
    return loadingTitle;
}

+ (UIColor *)loadingTitleColor
{
    if (!loadingTitleColor)
    {loadingTitleColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFScreen class]] colorForKey:THEME_KEY_LOADING_TITLE_COLOR] retain];}
    return loadingTitleColor;
}

//==============>> Themeable

- (void)themeChanged
{
    bgColor      = nil;
    bgOpacity    = nil;
    loadingTitle = nil;
}

+ (id<AFThemeable>)themeParentSectionClass
{return nil;}

+ (NSString *)themeSectionName
{return @"screen";}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"FFFFFF", THEME_KEY_LOADING_BG_COLOR,
            [NSNumber numberWithFloat:0.75f], THEME_KEY_LOADING_BG_OPACITY,
            @"Loading...", THEME_KEY_LOADING_TITLE,
            @"B85430", THEME_KEY_LOADING_TITLE_COLOR,
            nil];
}

//==============>> Dealloc

- (void)dealloc
{
    [viewController release];
    [[AFSession sharedSession] removeObserver:self];
    [observers release];
    [settingsSections release];
    [tabName release];
    [loadingLabel release];
    [loadingView release];
    [super dealloc];
}

@synthesize tabName, needsNavigationController, loadingLabel, loadingView;

@end
