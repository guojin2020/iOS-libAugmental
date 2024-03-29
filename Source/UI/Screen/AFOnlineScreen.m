#import "AFOnlineScreen.h"
#import "AFUnavailableOfflineViewController.h"
#import "AFDispatch.h"

@class AFSession;

@interface AFOnlineScreen ()

- (void)showOfflineView;

- (void)hideOfflineView;

@end

@implementation AFOnlineScreen

- (void)session:(AFSession *)changedSession becameOffline:(BOOL)offlineState
{
	dispatch_block_t block = ^
	{
		if(offlineState) [self showOfflineView];
		else             [self hideOfflineView];
	};

	AFBeginMainDispatch( block );
}

- (void)showOfflineView
{
    if (!offlineViewController)
    {
        offlineViewController = [[AFUnavailableOfflineViewController alloc] initWithTitle:[self defaultTabName]];
        //offlineViewController.view.transform = CGAffineTransformMakeTranslation(0.00f, [UIApplication sharedApplication].statusBarFrame.size.height);
        CGSize offlineViewSize = viewController.view.frame.size;
        [offlineViewController.view setFrame:CGRectMake(0, 0, offlineViewSize.width, offlineViewSize.height)];
        //[offlineViewController.view setBounds:self.view.bounds];
        [viewController.view addSubview:offlineViewController.view];
    }
}

- (void)hideOfflineView
{
    if (offlineViewController)
    {
        [offlineViewController.view removeFromSuperview];
        offlineViewController = nil;
    }
}

//============>> Themeable

- (void)themeChanged
{}


+ (id<AFPThemeable>)themeParentSectionClass
{return (id<AFPThemeable>)[AFScreen class];}

+ (NSString *)themeSectionName
{return nil;} //@"onlineScreen"
+ (NSDictionary *)defaultThemeSection
{return [NSDictionary dictionary];}

//============>> Dealloc

@end
