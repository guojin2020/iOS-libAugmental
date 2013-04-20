#import <UIKit/UIKit.h>

//#import "AFSessionObserver.h"
#import "AFScreenObserver.h"
#import "AFPThemeable.h"

#define THEME_KEY_BG_IMAGE_ENABLE           @"bgImageEnable"
#define THEME_KEY_BG_IMAGE_NAME             @"bgImageName"
#define THEME_KEY_BG_COLOR                    @"bgColor"
#define THEME_KEY_SWITCH_VIEW_SOUND            @"switchViewSound"

@class AFScreen;
@class NSMapTable;

@interface AFScreenManager : NSObject <UITabBarDelegate, UITabBarControllerDelegate, AFPThemeable, AFScreenObserver>
{
    NSMutableArray     *screens;
    UITabBarController *tabController;
    UIImage            *backgroundImage;
    UIImageView        *backgroundImageView;
}

- (void)setBackgroundImage:(UIImage *)newBackground;

- (void)addScreen:(AFScreen *)screen;

- (void)removeScreen:(AFScreen *)screen;

- (void)showScreen:(AFScreen *)screen;

- (void)hideScreen:(AFScreen *)screen;

- (void)setSelectedScreen:(AFScreen *)screen;

- (AFScreen *)selectedScreen;

- (NSArray *)screens;

- (AFScreen *)screenForName:(NSString *)name;

- (UIViewController *)viewControllerForName:(NSString *)name;

- (UIViewController *)viewControllerForScreen:(AFScreen *)screen;

- (AFScreen *)screenForViewController:(UIViewController *)viewController;

#ifdef BACKGROUND_IMAGE_ENABLED
-(void)setBackgroundImage:(UIImage*)newBackground;
#endif

+ (AFScreenManager *)sharedManager;

+ (NSString *)switchViewSound;

//=====>> Theme Getters

+ (NSString *)bgImageName;

+ (BOOL)bgImageEnable;

+ (UIColor *)bgColor;

@property(nonatomic, retain) UITabBarController *tabController;
@property(nonatomic, retain) UIImageView        *backgroundImageView;

@end
