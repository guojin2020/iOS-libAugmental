
#import <AVFoundation/AVFoundation.h>
#import "AFVideoPlayerViewController.h"
#import "AFVideoPlayerView.h"

@implementation AFVideoPlayerViewController

-(id)initWithAsset:(AVAsset *)assetIn
{
	self = [self init];
	if(self)
	{
		videoPlayerView = [[AFVideoPlayerView alloc] initWithAsset:assetIn];
    }
	return self;
}

-(id)initWithURL:(NSURL *)urlIn
{
	self = [self init];
	if(self)
	{
		videoPlayerView = [[AFVideoPlayerView alloc] initWithURL:urlIn];
	}
	return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (AVPlayer *)player { return videoPlayerView.player; }

-(void)loadView
{
	self.view = videoPlayerView;
}


@end