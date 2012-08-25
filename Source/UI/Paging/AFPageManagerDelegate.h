#import <UIKit/UIKit.h>

@class AFPage;

@protocol AFPageManagerDelegate

- (AFPage *)newPageForViewController:(UIViewController *)viewController;

- (UIBarButtonItem *)newNextBarButtonItemForPage:(AFPage *)page;

- (UIBarButtonItem *)newPreviousBarButtonItemForPage:(AFPage *)page;

- (NSString *)titleForPage:(AFPage *)page;

@end
