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
    self = [self initWithAsset:[[AFAVAssetCache sharedInstance] obtainAssetForURL:url]];
    if(self){}
    return self;
}

-(id)initWithAsset:(AVAsset*)asset
{
    self = [super init];
    if(self)
    {
        playerView = [[AFVideoPlayerView alloc] init];
        playerItem = [[AVPlayerItem alloc] initWithAsset:asset];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
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
    [self refresh];
}

- (void)refresh
{
    if ((self.player.currentItem != nil) && ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay))
    {
        self.playButton.enabled = YES;
    }
    else
    {
        self.playButton.enabled = NO;
    }
}

- (void)loadAssetFromFile
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"VideoFileName" withExtension:@"extension"];

    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSString *tracksKey = @"tracks";

    [asset loadValuesAsynchronouslyForKeys:@[tracksKey] completionHandler:
            ^{
                // The completion block goes here.
            }];
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
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
    return;
}

- (void)play
{
    [player play];
}



@end