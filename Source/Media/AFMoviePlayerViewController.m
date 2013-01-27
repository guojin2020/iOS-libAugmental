
#import <MediaPlayer/MediaPlayer.h>
#import "AFMoviePlayerViewController.h"

@implementation AFMoviePlayerViewController

- (id)initWithVideoURL:(NSURL *)videoURL
{
    self = [self init];
    if(self)
    {
        player = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [player play];
}

- (void)loadView
{
    [player prepareToPlay];
    self.view = player.view;
}

- (void)dealloc
{
    [player release];
    [super dealloc];
}

@end