
#import <UIKit/UIKit.h>




/*
 * Implementation of a ViewController which displays a detailed view of a database object
 * e.g. a customers account details or a product.
 */
@interface AFObjectViewController : UIViewController <UIScrollViewDelegate>
{
	IBOutlet UIScrollView* scrollView;
    IBOutlet UIPageControl* pageControl;
	NSMutableArray* viewControllers;
	BOOL pageControlUsed;
	int kNumberOfPages;
	Class objectType;
	
	UINavigationController* navController;
	
	NSArray* objects;
}

-(id)initWithObjects:(NSArray*)objectsIn;

-(IBAction)changePage:(id)sender;
-(void)loadScrollViewWithPage:(int)page;
-(void)scrollViewDidScroll:(UIScrollView*)sender;

@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property (nonatomic, retain) NSMutableArray* viewControllers;


@end
