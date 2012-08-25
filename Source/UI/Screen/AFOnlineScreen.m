#import "AFOnlineScreen.h"
#import "AFUnavailableOfflineViewController.h"

@class AFSession;

@interface AFOnlineScreen ()

- (void)showOfflineView;

- (void)hideOfflineView;

@end

@implementation AFOnlineScreen

- (void)session:(AFSession *)changedSession becameOffline:(BOOL)offlineState
{
    if (offlineState)
    {
        [self performSelectorOnMainThread:@selector(showOfflineView) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(hideOfflineView) withObject:nil waitUntilDone:NO];
    }
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
        [offlineViewController release];
        offlineViewController = nil;
    }
}

//============>> Themeable

- (void)themeChanged
{}

- (void)dealloc
{
    [offlineViewController release];
    [super dealloc];
}

+ (Class <AFThemeable>)themeParentSectionClass
{return [AFScreen class];}

+ (NSString *)themeSectionName
{return nil;} //@"onlineScreen"
+ (NSDictionary *)defaultThemeSection
{return [NSDictionary dictionary];}

//============>> Dealloc

@end
