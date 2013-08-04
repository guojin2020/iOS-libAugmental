#import "AFPage.h"
#import "AFValidatable.h"
#import "AFPageManager.h"

//@interface AFPage ()
//@end

@implementation AFPage

- (id)initWithViewController:(UIViewController *)viewControllerIn
{
    if ((self = [self init]))
    {
        viewController        = viewControllerIn;
        title                 = nil;
        manager               = nil;
        nextBarButtonItem     = nil;
        previousBarButtonItem = nil;
        //[self updateNavigationItems];
    }
    return self;
}

- (void)setManager:(AFPageManager *)managerIn
{
    AFPageManager *oldManager = manager;
    manager = managerIn;

    [self updateNavigationItems];
}

- (NSString *)pagePositionString
{
    return [NSString stringWithFormat:@"%i/%i", [manager indexOfPage:self], [manager pageCount]];
}

- (void)updateNavigationItems
{
    if (viewController && manager)
    {
        if (previousBarButtonItem)
        {
            viewController.navigationItem.leftBarButtonItem  = previousBarButtonItem;
        }
        else
        {
            UIBarButtonItem *item = [manager.delegate newPreviousBarButtonItemForPage:self];
            viewController.navigationItem.leftBarButtonItem = item;
        }

        if (nextBarButtonItem)
        {
            viewController.navigationItem.rightBarButtonItem = nextBarButtonItem;
        }
        else
        {
            UIBarButtonItem *item = [manager.delegate newNextBarButtonItemForPage:self];
            viewController.navigationItem.rightBarButtonItem = item;
        }

        viewController.title = title ? title : [manager.delegate titleForPage:self];
    }
}

- (void)setPreviousBarButtonItem:(UIBarButtonItem *)newItem
{
    UIBarButtonItem *oldItem = previousBarButtonItem;
    previousBarButtonItem = newItem;
    if (viewController)
    {
        if (previousBarButtonItem)
        {
            viewController.navigationItem.leftBarButtonItem = previousBarButtonItem;
        }
        else
        {
            UIBarButtonItem *item = [manager.delegate newPreviousBarButtonItemForPage:self];
            viewController.navigationItem.leftBarButtonItem = item;
        }
    }
}

- (void)setNextBarButtonItem:(UIBarButtonItem *)newItem
{
    UIBarButtonItem *oldItem = nextBarButtonItem;
    nextBarButtonItem = newItem;
    if (viewController)
    {
        if (nextBarButtonItem)
        {
            viewController.navigationItem.rightBarButtonItem = nextBarButtonItem;
        }
        else
        {
            UIBarButtonItem *item = [manager.delegate newNextBarButtonItemForPage:self];
            viewController.navigationItem.rightBarButtonItem = item;
        }
    }
}

- (UIBarButtonItem *)nextBarButtonItem
{return nextBarButtonItem;}

- (UIBarButtonItem *)previousBarButtonItem
{return previousBarButtonItem;}

- (BOOL)mayGoToNextStep
{
    BOOL answer;

    if ([viewController conformsToProtocol:@protocol(AFValidatable)])
    {
        if ([(id)viewController respondsToSelector:@selector(validateWithInvalidUserAlert)])
        {
            answer = [(NSObject <AFValidatable> *) viewController validateWithInvalidUserAlert];
        }
        else
        {
            answer = [((NSObject <AFValidatable> *) viewController) valid];
        }
    }
    else answer = YES;

    return answer;
}

- (BOOL)mayGoToPreviousStep
{
    return YES;
}

- (BOOL)isRoot
{
    BOOL isRoot = self == [manager pageAtIndex:0];
    return isRoot;
}

- (BOOL)isLast
{
    BOOL isLast = self == [manager pageAtIndex:[manager pageCount] - 1];
    return isLast;
}

- (void)setViewController:(UIViewController *)newViewController
{
    UIViewController *oldViewController = viewController;
    viewController = newViewController;

    title = viewController.title;

    [self updateNavigationItems];
    [manager viewControllerChanged:self was:oldViewController];

}

- (NSString *)title
{return title ? title : viewController.title;}

- (void)setTitle:(NSString *)titleIn
{
    NSString *oldTitle = title;
    title = titleIn;

    if (viewController) viewController.title = title ? title : [manager.delegate titleForPage:self];
}


@synthesize viewController, manager;

@end
