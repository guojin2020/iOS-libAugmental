//
// Created by augmental on 14/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFVideoPlayerViewController.h"

#import "AFVideoPlayerView.h"
#import "AFAVAssetCache.h"

@implementation AFVideoPlayerViewController

static const NSString *ItemStatusContext;

-(id)initWithURL:(NSURL*)url
{
    AVAsset* asset = [[AFAVAssetCache sharedInstance] obtainAssetForURL:url];

    autoPlay = YES;

    self = [self initWithAsset:asset];
    if(self){}
    return self;
}

-(id)initWithAsset:(AVAsset*)asset
{
    self = [super init];
    if(self)
    {
        NSString *tracksKey = @"tracks";

        playerView = [[AFVideoPlayerView alloc] init];
        playerItem = [[AVPlayerItem alloc] initWithAsset:asset];

        [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:
                ^{
                    dispatch_async(dispatch_get_main_queue(),
                            ^{
                                NSError *error;
                                AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];

                                if (status == AVKeyValueStatusLoaded)
                                {
                                    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                                    [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
                                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                                             selector:@selector(playerItemDidReachEnd:)
                                                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                                                               object:self.playerItem];
                                    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                                    [self.playerView setPlayer:self.player];
                                }
                                else
                                {
                                    NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                                }
                            });
                }];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];

        playButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    }
    return self;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
}

- (void)loadView
{
    [super loadView];

    playerView = [[AFVideoPlayerView alloc] init];

    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    playerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)refresh
{
    if ((self.player.currentItem != nil) && ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay))
    {
        self.playButton.enabled = YES;

        if(autoPlay) [player play];
    }
    else
    {
        self.playButton.enabled = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (context == &ItemStatusContext)
    {
        dispatch_async(dispatch_get_main_queue(),
                ^{
                    [self refresh];
                });
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    return;
}

- (void)dealloc
{
    [player release];
    [playerItem release];
    [playerView release];
    [playButton release];
    [super dealloc];
}

@synthesize player;
@synthesize playerItem;
@synthesize playerView;
@synthesize playButton;

@end