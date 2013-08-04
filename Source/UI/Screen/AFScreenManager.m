#import "AFScreenManager.h"
#import "AFScreen.h"
//#import "AFAppDelegate.h"
#import "AFThemeManager.h"
#import "AFLog.h"

static AFScreenManager *sharedManager = nil;

static NSString *bgImageName     = nil;
static NSNumber *bgImageEnable   = nil;
static UIColor  *bgColor         = nil;
static NSString *switchViewSound = nil;

@interface AFScreenManager ()

- (void)updateTabBarAnimated:(BOOL)animated;

@end

@implementation AFScreenManager

+ (AFScreenManager *)sharedManager
{
    if (!sharedManager) sharedManager = [[AFScreenManager alloc] init];
    return sharedManager;
}

- (id)init
{
    if ((self = [super init]))
    {
        screens = [[NSMutableArray alloc] init];

        tabController = [[UITabBarController alloc] init];
        tabController.view.autoresizesSubviews = YES;
        tabController.delegate                 = self;

        tabController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NSDictionary *themeSection = [AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFScreenManager class]];
        tabController.view.backgroundColor = [themeSection colorForKey:THEME_KEY_BG_COLOR];

        tabController.view.opaque = YES;
        [self themeChanged];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)newBackground
{
    //UIImage *oldBackground = backgroundImage;
    backgroundImage = newBackground;

    [backgroundImageView setImage:newBackground];
}

- (void)updateTabBarAnimated:(BOOL)animated
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:[screens count]];
    for (AFScreen  *screen in screens)
    {
        [viewControllers addObject:screen.viewController.navigationController ? screen.viewController.navigationController : screen.viewController];
    }
    [tabController setViewControllers:viewControllers animated:animated];
}

- (void)addScreen:(AFScreen *)screen
{
    if (screen.needsNavigationController) //Wrap the screen in a navigation controller if it needs it.
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:screen.viewController];
        NSAssert(screen.viewController.navigationController == navController, @"ViewController didn't get wrapped!");
        screen.viewController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

    [screens addObject:screen];
    [screen addScreenObserver:self];

    [self updateTabBarAnimated:NO];
}

- (void)showScreen:(AFScreen *)screen
{
    [self setSelectedScreen:screen];
}

- (void)hideScreen:(AFScreen *)screen
{
    int screenIndex = [screens indexOfObject:screen];
    [screens removeObjectAtIndex:(NSUInteger) screenIndex];

    [tabController setViewControllers:screens animated:YES];
}

- (void)screenBecameInactive:(AFScreen *)screen
{[self hideScreen:screen];}

- (void)screenBecameActive:(AFScreen *)screen
{[self showScreen:screen];}

- (void)removeScreen:(AFScreen *)screen
{
    //if(screen.needsNavigationController)[screen.navigationController release];
    [screens removeObject:screen];
    [self updateTabBarAnimated:NO];
}


- (void)setSelectedScreen:(AFScreen *)screen
{
    [screen viewControllerWillAppear:NO];
    [tabController setSelectedViewController:[self viewControllerForScreen:screen]];
}

- (AFScreen *)selectedScreen
{
    return [self screenForViewController:tabController.selectedViewController];
}

- (void)setTabBarItemForScreen:(AFScreen *)screen
{
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:screen.tabName image:[screen tabBarIcon] tag:0];
    screen.viewController.tabBarItem = item;
}

- (NSArray *)screens
{return screens;}

- (UIViewController *)viewControllerForScreen:(AFScreen *)screen
{
    return screen.viewController.navigationController ? screen.viewController.navigationController : screen.viewController;
}

- (AFScreen *)screenForViewController:(UIViewController *)viewController
{
    UINavigationController *navController;
    for (AFScreen          *screen in screens)
    {
        navController = screen.viewController.navigationController;
        if ((navController && viewController == navController) || screen.viewController == viewController) return screen;
    }
    return nil;
}

- (AFScreen *)screenForName:(NSString *)name
{
    for (AFScreen *screen in screens)
    {
        if ([screen.tabName isEqualToString:name])return screen;
    }
    return nil;
}

- (UIViewController *)viewControllerForName:(NSString *)name
{
    for (AFScreen *screen in screens)
    {
        if ([screen.tabName isEqualToString:name])return screen.viewController.navigationController ? screen.viewController.navigationController : screen.viewController;
    }
    return nil;
}

- (void)screenViewControllerChanged:(AFScreen *)screen from:(UIViewController *)oldController
{
    if (oldController && screen.viewController != oldController)
    {
        AFLog(@"Updating Tab Bar due to screenViewController change");


        UIViewController *controller;
        if (screen.needsNavigationController) //Wrap the screen in a navigation controller if it needs it.
        {
            controller = [[UINavigationController alloc] initWithRootViewController:screen.viewController];
            ((UINavigationController *) controller).navigationBar.barStyle = UIBarStyleBlack;
        }
        else
        {
            controller = screen.viewController;
        }


        [self updateTabBarAnimated:NO];
    }
}

//======>> Tab Controller Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //FIX!!!
    //[AFAppDelegate playSound:[AFScreenManager switchViewSound]];
    [[self screenForViewController:viewController] viewControllerWillAppear:NO];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{return YES;}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers
{}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{}

//============>> Theme Getters

+ (NSString *)bgImageName
{
    if (!bgImageName)
    {bgImageName = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFScreenManager class]] valueForKey:THEME_KEY_BG_IMAGE_NAME];}
    return bgImageName;
}

+ (BOOL)bgImageEnable
{
    if (!bgImageEnable)
    {bgImageEnable = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFScreenManager class]] valueForKey:THEME_KEY_BG_IMAGE_ENABLE];}
    return [bgImageEnable boolValue];
}

+ (UIColor *)bgColor
{
    if (!bgColor)
    {bgColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFScreenManager class]] colorForKey:THEME_KEY_BG_COLOR];}
    return bgColor;
}

+ (NSString *)switchViewSound
{
    if (!switchViewSound)switchViewSound = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFScreenManager class]] valueForKey:THEME_KEY_SWITCH_VIEW_SOUND];
    return switchViewSound;
}

//============>> Themeable

- (void)themeChanged
{
    bgImageName     = nil;
    bgImageEnable   = nil;
    bgColor         = nil;
    switchViewSound = nil;

    /*
     NSDictionary* themeSection = [AFThemeManager themeSectionForClass:[AFScreenManager class]];

     if([themeSection boolForKey:THEME_KEY_BG_IMAGE_ENABLE])
     {
         UIImage* bgImage = [UIImage imageNamed:[themeSection valueForKey:THEME_KEY_BG_IMAGE_NAME]];

         if(!backgroundImageView) backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
         else [self setBackgroundImage:bgImage];

         //AFLog(@"SETTING BG TO %@",[themeSection colorForKey:THEME_KEY_BG_COLOR]);
         [tabController.view setBackgroundColor:[themeSection colorForKey:THEME_KEY_BG_COLOR]];

         if(backgroundImageView.superview!=tabController.view)[tabController.view addSubview:backgroundImageView];
         [tabController.view sendSubviewToBack:backgroundImageView];
     }
     else
     {
         if(backgroundImageView.superview==tabController.view)[backgroundImageView removeFromSuperview];
         self.backgroundImageView = nil;
     }
     */
}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], THEME_KEY_BG_IMAGE_ENABLE,
            @"BG.PNG", THEME_KEY_BG_IMAGE_NAME,
            @"FFFFFF", THEME_KEY_BG_COLOR,
            @"beep-30", THEME_KEY_SWITCH_VIEW_SOUND,
            nil];
}

+ (id<AFPThemeable>)themeParentSectionClass
{return nil;}

+ (NSString *)themeSectionName
{return @"screenManager";}

//==========>> Dealloc


@synthesize tabController, backgroundImageView;

@end
