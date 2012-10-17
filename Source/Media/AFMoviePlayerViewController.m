//
// Created by augmental on 17/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import "AFMoviePlayerViewController.h"


@implementation AFMoviePlayerViewController

- (id)initWithVideoURL:(NSURL *)videoURL
{
    self = [super init];
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

@end