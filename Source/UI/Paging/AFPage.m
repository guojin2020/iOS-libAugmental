#import "AFPage.h"
#import "AFValidatable.h"
#import "AFPageManager.h"

//@interface AFPage ()
//@end

@implementation AFPage

- (id)initWithViewController:(UIViewController *)viewControllerIn
{
    if ((self = [super init]))
    {
        viewController        = [viewControllerIn retain];
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
    manager = [managerIn retain];
    [oldManager release];

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
        viewController.navigationItem.leftBarButtonItem  = previousBarButtonItem ? previousBarButtonItem : [manager.delegate newPreviousBarButtonItemForPage:self];
        viewController.navigationItem.rightBarButtonItem = nextBarButtonItem ? nextBarButtonItem : [manager.delegate newNextBarButtonItemForPage:self];
        viewController.title                             = title ? title : [manager.delegate titleForPage:self];
    }
}

- (void)setPreviousBarButtonItem:(UIBarButtonItem *)newItem
{
    UIBarButtonItem *oldItem = previousBarButtonItem;
    previousBarButtonItem = [newItem retain];
    if (viewController) viewController.navigationItem.leftBarButtonItem = previousBarButtonItem ? previousBarButtonItem : [manager.delegate newPreviousBarButtonItemForPage:self];
    [oldItem release];
}

- (void)setNextBarButtonItem:(UIBarButtonItem *)newItem
{
    UIBarButtonItem *oldItem = nextBarButtonItem;
    nextBarButtonItem = [newItem retain];
    if (viewController) viewController.navigationItem.rightBarButtonItem = nextBarButtonItem ? nextBarButtonItem : [manager.delegate newNextBarButtonItemForPage:self];
    [oldItem release];
}

- (UIBarButtonItem *)nextBarButtonItem
{return nextBarButtonItem;}

- (UIBarButtonItem *)previousBarButtonItem
{return previousBarButtonItem;}

- (BOOL)mayGoToNextStep
{
    if ([viewController conformsToProtocol:@protocol(AFValidatable)])
    {
        if ([viewController respondsToSelector:@selector(validateWithInvalidUserAlert)])
        {
            return [(NSObject <AFValidatable> *) viewController validateWithInvalidUserAlert];
        }
        else
        {
            return [((NSObject <AFValidatable> *) viewController) valid];
        }
    }
    else return YES;
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
    viewController = [newViewController retain];

    title = viewController.title;

    [self updateNavigationItems];
    [manager viewControllerChanged:self was:oldViewController];

    [oldViewController release];
}

- (NSString *)title
{return title ? title : viewController.title;}

- (void)setTitle:(NSString *)titleIn
{
    NSString *oldTitle = title;
    title = [titleIn retain];
    [oldTitle release];

    if (viewController) viewController.title = title ? title : [manager.delegate titleForPage:self];
}

- (void)dealloc
{
    [viewController release];
    [manager release];
    [previousBarButtonItem release];
    [nextBarButtonItem release];
    [title release];
    [title release];
    [manager release];
    [super dealloc];
}

@synthesize title, viewController, manager;

@end
