// Controls a view that can show many AFObjects (objects providing a panel view) as pages

#import "AFObjectViewController.h"
#import "AFObjectViewPanelController.h"

#import <objc/runtime.h>

@implementation AFObjectViewController

- (id)initWithObjects:(NSArray *)objectsIn
{
    self = [self initWithNibName:@"AFObjectView" bundle:[NSBundle mainBundle]];

    objects = [objectsIn retain];

    //Checking that the input is sane (all elements of the input array are AFObjects of the same type )
    if (!objects || [objects count] == 0)
    {
        return nil;
    }
    objectType = [[objects objectAtIndex:0] class];
    if (![[objects objectAtIndex:0] conformsToProtocol:@protocol(AFObject)])
    {
        return nil;
    }

    for (int i = 1; i < [objects count]; i++)
        if (![[objects objectAtIndex:i] isKindOfClass:objectType])
        {
            return nil;
        }

    kNumberOfPages = [objects count];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];

    // a page is the width of the scroll view
    scrollView.pagingEnabled                  = YES;
    scrollView.contentSize                    = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.scrollsToTop                   = NO;
    scrollView.delegate                       = self;

    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage   = 0;

    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0) return;
    if (page >= kNumberOfPages) return;

    // replace the placeholder if necessary
    UIViewController *viewController = [viewControllers objectAtIndex:page];

    if ((NSNull *) viewController == [NSNull null])
    {
        NSObject <AFObject_PanelViewable> *pageViewObject = [objects objectAtIndex:page];

        Class <AFObjectViewPanelController> viewPanelControllerClass = [((Class <AFObject_PanelViewable>) [pageViewObject class]) viewPanelClass];
        if (viewPanelControllerClass)
        {
            viewController = (UIViewController *) [((NSObject <AFObjectViewPanelController> *) NSAllocateObject(viewPanelControllerClass, 0, nil)) initWithObject:pageViewObject];
        }
        else
        {
            //TODO: Change this to a more meaningful placeholder
            viewController = [[UIViewController alloc] init];
        }

        [viewControllers replaceObjectAtIndex:page withObject:viewController];
        [viewController release];
    }

    // add the controller's view to the scroll view
    if (!viewController.view.superview)
    {
        CGRect targetFrame = scrollView.frame;
        CGRect sourceFrame = viewController.view.frame;

        targetFrame.origin.x = (targetFrame.size.width * page); //+ (targetFrame.size.width-sourceFrame.size.width)/2;
        targetFrame.origin.y = 0; // (targetFrame.size.height-sourceFrame.size.height)/2;

        CGAffineTransform centerUp = CGAffineTransformMakeTranslation(viewController.view.transform.tx + (targetFrame.size.width - sourceFrame.size.width) / 2, viewController.view.transform.ty + 16 + (targetFrame.size.height - sourceFrame.size.height) / 2);

        viewController.view.frame     = targetFrame;
        viewController.view.transform = centerUp;

        [scrollView addSubview:viewController.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int     page      = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;

    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [objects release];
    [viewControllers release];
    [scrollView release];
    [pageControl release];
    [super dealloc];
}

@synthesize scrollView, pageControl, viewControllers;

@end
