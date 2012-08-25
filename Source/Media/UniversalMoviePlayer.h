#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomMoviePlayerViewController.h"

@interface UniversalMoviePlayer : NSObject
{
    //MPMoviePlayerViewController *playerViewController;
    //MPMoviePlayerController *playerController;

    //UIViewController* modalParentViewController;

    CustomMoviePlayerViewController *moviePlayer;
}

+ (UniversalMoviePlayer *)sharedInstance;

- (void)playVideo:(NSURL *)url comingFromViewController:(UIViewController *)videoOverviewViewControllerIn;
//-(void) movieDidExitFullscreen:(NSNotification*) aNotification;
//-(void) moviePlayerDidFinish:(NSNotification*) aNotification;

//@property (nonatomic, retain) UIViewController* modalParentViewController;
//@property (nonatomic, retain) MPMoviePlayerViewController *playerViewController;
//@property (nonatomic, retain) MPMoviePlayerController *playerController;

@end
