#import <UIKit/UIKit.h>

@class AFPage;

@protocol AFPageObserver

- (void)viewControllerChanged:(AFPage *)page was:(UIViewController *)viewController;

@end
