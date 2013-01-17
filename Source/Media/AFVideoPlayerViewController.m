
#import <AVFoundation/AVFoundation.h>
#import "AFVideoPlayerViewController.h"
#import "AFVideoPlayerView.h"

@implementation AFVideoPlayerViewController

-(id)initWithAsset:(AVAsset *)assetIn
{
	self = [super init];
	if(self)
	{
		videoPlayerView = [[AFVideoPlayerView alloc] initWithAsset:assetIn];
	}
	return self;
}

-(id)initWithURL:(NSURL *)urlIn
{
	self = [super init];
	if(self)
	{
		videoPlayerView = [[AFVideoPlayerView alloc] initWithURL:urlIn];
	}
	return self;
}

- (AVPlayer *)player { return videoPlayerView.player; }

-(void)loadView
{
	self.view = videoPlayerView;
}

@end