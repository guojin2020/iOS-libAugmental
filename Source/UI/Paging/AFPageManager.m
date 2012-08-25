#import "AFPageManager.h"
#import "AFPage.h"

@interface AFPageManager ()

- (void)nextButtonPressed;

- (void)backButtonPressed;

@end

@implementation AFPageManager

- (id)initWithNavigationController:(UINavigationController *)navControllerIn
{
    return [self initWithNavigationController:navControllerIn delegate:nil];
}

- (id)initWithNavigationController:(UINavigationController *)navControllerIn delegate:(NSObject <AFPageManagerDelegate> *)delegateIn
{
    if ((self = [super init]))
    {
        navController = [navControllerIn retain];

        delegate = delegateIn ? delegateIn : self;

        pages = [[NSMutableArray alloc] initWithCapacity:[[navController viewControllers] count]];

        AFPage                *page;
        for (UIViewController *controller in [navController viewControllers])
        {
            page = [delegate newPageForViewController:controller];
            [self addPage:page];
            [page release];
        }

        observers = [[NSMutableSet alloc] init];
    }
    return self;
}

- (AFPage *)currentPage
{return (AFPage *) [pages objectAtIndex:[[navController viewControllers] count] - 1];}

- (AFPage *)addViewControllerAsPage:(UIViewController *)viewController
{
    AFPage *page = [delegate newPageForViewController:viewController];
    [self addPage:page];
    [page release];
    return page;
}

- (void)addPage:(AFPage *)pageIn
{
    [pages addObject:pageIn];
    pageIn.manager = self;
    for (AFPage *page in pages)[page updateNavigationItems];
}

- (void)removePage:(AFPage *)pageIn
{
    if ([pages containsObject:pageIn])
    {
        [pages removeObject:pageIn];
        pageIn.manager = nil;
        for (AFPage *page in pages)[page updateNavigationItems];
    }
}

- (int)pageCount
{
    int pageCount = [pages count];
    return pageCount;
}

- (int)currentPageIndex
{
    int currentPageIndex = [[navController viewControllers] count] - 1;
    return currentPageIndex;
}

- (void)goToPageIndex:(int)pageIndex animated:(BOOL)animated
{
    while ([self currentPageIndex] > pageIndex)
    {
        [navController popViewControllerAnimated:animated];
    }

    while ([self currentPageIndex] < pageIndex)
    {
        [navController pushViewController:[self nextPage].viewController animated:animated];
    }
}

- (AFPage *)pageAtIndex:(int)pageIndex
{return (AFPage *) [pages objectAtIndex:pageIndex];}

- (void)addObserver:(NSObject <AFPageObserver> *)observerIn
{[observers addObject:observerIn];}

- (void)removeObserver:(NSObject <AFPageObserver> *)observerIn
{[observers removeObject:observerIn];}

- (void)viewControllerChanged:(AFPage *)page was:(UIViewController *)oldViewController
{
    int currentPageIndex = [self currentPageIndex];
    int changedPageIndex = [self indexOfPage:page];

    NSAssert(changedPageIndex > 0, @"Tried to change the viewController of the root page.");

    [self goToPageIndex:changedPageIndex - 1 animated:NO];
    [self goToPageIndex:currentPageIndex animated:NO];

    for (NSObject <AFPageObserver> *observer in observers)
    {[observer viewControllerChanged:page was:oldViewController];}
}

- (void)nextButtonPressed
{[self navigateToNextPageAnimated:YES];}

- (int)indexOfPage:(AFPage *)page
{return [pages indexOfObject:page];}

- (void)backButtonPressed
{[self navigateToPreviousPageAnimated:YES];}

- (void)navigateToPreviousPageAnimated:(BOOL)animated
{
    AFPage *previousPage = [self previousPage];

    if (previousPage && [[self currentPage] mayGoToPreviousStep])
    {
        [navController popViewControllerAnimated:animated];
    }
}

- (AFPage *)rootPage
{return [self pageAtIndex:0];}

- (void)navigateToNextPageAnimated:(BOOL)animated
{
    AFPage *nextPage    = [self nextPage];
    AFPage *currentPage = [self currentPage];

    if (nextPage && [currentPage mayGoToNextStep])
    {
        [navController pushViewController:nextPage.viewController animated:animated];
    }
}

- (BOOL)atLastPage
{
    BOOL atLastPage = [self currentPageIndex] == [pages count] - 1;
    return atLastPage;
}

- (BOOL)atRootPage
{
    BOOL atRootPage = [self currentPageIndex] == 0;
    return atRootPage;
}

- (AFPage *)nextPage
{
    return [self atLastPage] ? nil : [self pageAtIndex:[self currentPageIndex] + 1];
}

- (AFPage *)previousPage
{
    return [self atRootPage] ? nil : [self pageAtIndex:[self currentPageIndex] - 1];
}

- (NSEnumerator *)pageEnumerator
{return [pages objectEnumerator];}

//Default PageManagerDelegate implementation

- (AFPage *)newPageForViewController:(UIViewController *)viewController
{
    AFPage *newPage = [[AFPage alloc] initWithViewController:viewController];

    newPage.title                 = viewController.navigationItem.title;
    newPage.nextBarButtonItem     = viewController.navigationItem.rightBarButtonItem;
    newPage.previousBarButtonItem = viewController.navigationItem.leftBarButtonItem;

    return newPage;
}

- (UIBarButtonItem *)rightBarButtonItemForFinalPage
{
    return nil;
}

- (UIBarButtonItem *)newPreviousBarButtonItemForPage:(AFPage *)page
{
    return [page isRoot] ? nil : [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self action:@selector(backButtonPressed)];
}

/*
 UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed)];
 viewController.navigationItem.leftBarButtonItem = backButton;
 [backButton release];
 */

- (UIBarButtonItem *)newNextBarButtonItemForPage:(AFPage *)page
{
    return [page isLast] ? nil : [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(nextButtonPressed)];
}

/*
 UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:(i==0?@"Checkout":i>=[pageManager pageCount]-1?@"Confirm & Pay":@"Next") style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonPressed)];
 viewController.navigationItem.rightBarButtonItem = nextButton;
 [nextButton release];
 */

- (NSString *)titleForPage:(AFPage *)page
{
    return [NSString stringWithFormat:@"Step %i/%i", [self indexOfPage:page] + 1, [self pageCount]];
}

// viewController.navigationItem.title = i==0?@"Basket":[NSString stringWithFormat:@"%i/%i: %@",i,[pageManager pageCount],viewController.title];

- (void)dealloc
{
    [pages release];
    [observers release];
    [navController release];
    [super dealloc];
}

@synthesize delegate;

@end
