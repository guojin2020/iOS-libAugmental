#import <Foundation/Foundation.h>

#import "AFPageObserver.h"
#import "AFPageManagerDelegate.h"

@interface AFPageManager : NSObject <AFPageObserver, AFPageManagerDelegate>
{
    NSMutableArray *pages;
    NSMutableSet   *observers;

    //int currentPageIndex;

    UINavigationController *navController;

    NSObject <AFPageManagerDelegate> *__weak delegate;
}

- (id)initWithNavigationController:(UINavigationController *)navControllerIn;

- (id)initWithNavigationController:(UINavigationController *)navControllerIn delegate:(NSObject <AFPageManagerDelegate> *)delegateIn;

- (AFPage *)currentPage;

- (AFPage *)nextPage;

- (AFPage *)previousPage;

- (void)goToPageIndex:(int)pageIndex animated:(BOOL)animated;

- (AFPage *)pageAtIndex:(int)pageIndex;

- (int)indexOfPage:(AFPage *)page;

- (int)currentPageIndex;

- (int)pageCount;

- (BOOL)atLastPage;

- (BOOL)atRootPage;

- (AFPage *)rootPage;

- (AFPage *)addViewControllerAsPage:(UIViewController *)viewController;

- (void)addPage:(AFPage *)pageIn;

- (void)removePage:(AFPage *)pageIn;

- (void)addObserver:(NSObject <AFPageObserver> *)observerIn;

- (void)removeObserver:(NSObject <AFPageObserver> *)observerIn;

- (void)navigateToPreviousPageAnimated:(BOOL)animated;

- (void)navigateToNextPageAnimated:(BOOL)animated;

- (NSEnumerator *)pageEnumerator;

@property(weak, nonatomic, readonly) NSObject <AFPageManagerDelegate> *delegate;

@end
