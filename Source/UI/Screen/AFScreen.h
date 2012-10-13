#import <UIKit/UIKit.h>

#import "AFSettingsProvider.h"
#import "AFSessionObserver.h"
#import "AFThemeable.h"

#define THEME_KEY_LOADING_BG_COLOR        @"bgColor"
#define THEME_KEY_LOADING_BG_OPACITY    @"bgOpacity"
#define THEME_KEY_LOADING_TITLE            @"loadingTitle"
#define THEME_KEY_LOADING_TITLE_COLOR    @"loadingTitleColor"

@class AFSession;
@class AFSettingsSection;
@class AFScreenLoadingViewController;

@protocol AFScreenObserver;

/**
 * Implements functionality common to all Screens
 * This is not a complete implementation of a Screen and needs to be subclassed for use
 */
@interface AFScreen : NSObject <AFSettingsProvider, AFSessionObserver, AFThemeable>
{
    BOOL needsNavigationController;
    UIViewController *viewController;

    NSArray      *settingsSections;
    NSMutableSet *observers;
    NSString     *tabName;
    BOOL active;
    BOOL needsInit;

    UIView  *loadingView;
    UILabel *loadingLabel;
}

/*
 *	Quickly initialises this screen object, without performing any extensive ViewController intialisation.
 *	This initialiser is not intended to be overridden. 
 */
- (id)initNeedingNavigationController:(BOOL)needsNavigationController;

/*
 *	Returns the value set during initialisation. This is polled by AFScreenManager to determine
 *	whether or not this Screens viewController should be wrapped in a NavigationController before
 *	being added to the UITabBar hierarchy. This method should not be overridden.
 */
- (BOOL)needsNavigationController;

/*
 *	Convenience method, equivalent to calling self.viewController.navigationController.
 *	This method should not be overridden.
 */
- (UINavigationController *)navigationController;

/*
 *	Should return an icon to be used when ScreenManager represents this screen on the iOS tab bar.
 *	This is only polled when the screen is added to the ScreenManager. The default implementation
 *	invokes +(UIImage*)defaultTabBarIcon. Either implement this Class method in your subclass or
 *	override this method directly to provide the icon.
 */
- (UIImage *)tabBarIcon;

/*
 *	Perform the fastest possible load of this screens top-level view controller.
 *	Do not include large amounts of initialisation here, this should go in viewControllerBackgroundInit.
 *
 *	The default implementation sets viewController as a default UIViewController. Subclasses may set
 *  the viewController field to some other UIViewController subclass and do not need to call [super loadViewController];
 */
- (void)loadViewController;

- (BOOL)viewControllerIsLoaded;

/*
 *	This method is invoked by viewControllerWillApear, on a background thread, so that main viewController
 *  content gets initialized on a demand basis.
 *
 *	User applications should over-ride this method to provide an implementation, but never invoke it directly.
 *	When the initialisation has finished, the Appliction should call viewControllerDidLoad.
 */
- (void)viewControllerBackgroundInit;

/*
 *	This method should be called by the user-application when initialisation of this Screens viewController is
 *  fully completed, this will usually be at the end of viewControllerBackgroundInit. This removes the
 *  "Loading..." subview from the now loaded view, so that it is ready for the USER to start interacting with.
 *
 *	Overriding implementations should always call [super viewControllerDidLoad];
 */
- (void)viewControllerDidLoad;

/*
 *	This method will be called by the Screens associated ScreenManager whenever it is about to appear (i.e. when
 *	it has been selected on the Tab Bar.). The first time this method is invoked, viewControllerBackgroundInit is
 *	executed on a background thread to complete initialisation of the viewController.
 *
 *	Because of this, all overriding implementations must call [super viewControllerWillAppear] or the viewController will
 *	not be initialized properly.
 */
- (void)viewControllerWillAppear:(BOOL)animated;

- (void)addScreenObserver:(NSObject <AFScreenObserver> *)observer;

- (void)removeScreenObserver:(NSObject <AFScreenObserver> *)observer;

- (void)setActive:(BOOL)nowActive;

- (void)refreshActive;

//+(UIImage*)defaultTabBarIcon;
+ (NSString *)defaultTitle;

+ (NSString *)defaultTabName;

- (void)setViewController:(UIViewController *)viewControllerIn animated:(BOOL)animatedIn;

+ (UIColor *)bgColor;

+ (float)bgOpacity;

+ (NSString *)loadingTitle;

+ (UIColor *)loadingTitleColor;

@property(nonatomic, readonly) BOOL active;
@property(nonatomic, readonly) BOOL needsNavigationController;
@property(nonatomic, readonly) UINavigationController *navigationController;

@property(nonatomic, readonly) UIImage  *defaultTabBarIcon;
@property(nonatomic, readonly) NSString *defaultTitle;
@property(nonatomic, readonly) NSString *defaultTabName;

@property(nonatomic, retain) UIViewController *viewController;

@property(nonatomic, retain) NSString *tabName;

@property(nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property(nonatomic, retain) IBOutlet UIView  *loadingView;

@end
