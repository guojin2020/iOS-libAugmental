
#import <MediaPlayer/MediaPlayer.h>
#import "AFMoviePlayerViewController.h"
#import "AFAssertion.h"

@implementation AFMoviePlayerViewController

- (id)initWithVideoURL:(NSURL *)videoURL
{
	AFAssertMainThread();

    self = [self init];
    if(self)
    {
        player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	AFAssertMainThread();

    [super viewDidAppear:animated];
    [player play];
}

- (void)loadView
{
	AFAssertMainThread();

    [player prepareToPlay];
	player.controlStyle = MPMovieControlModeHidden;
    self.view = player.view;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

@end