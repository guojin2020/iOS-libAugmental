#import <Foundation/Foundation.h>

@class AFPageManager;

@interface AFPage : NSObject
{
    NSString         *title;
    UIViewController *viewController;
    AFPageManager    *manager;

    UIBarButtonItem *nextBarButtonItem;
    UIBarButtonItem *previousBarButtonItem;
}

- (id)initWithViewController:(UIViewController *)viewControllerIn;

- (NSString *)pagePositionString;

- (BOOL)mayGoToNextStep;

- (BOOL)mayGoToPreviousStep;

- (BOOL)isRoot;

- (BOOL)isLast;

- (void)updateNavigationItems;

@property(nonatomic, strong) NSString         *title;
@property(nonatomic, strong) UIBarButtonItem  *nextBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem  *previousBarButtonItem;
@property(nonatomic, strong) UIViewController *viewController;
@property(nonatomic, strong) AFPageManager    *manager;

@end
