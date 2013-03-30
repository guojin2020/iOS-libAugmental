//
// Created by Chris Hatton on 14/10/2012.
// Contact: christopherhattonuk@gmail.com
//

#define TRACKS_KEY @"tracks"

#import "AFVideoPlayerView.h"
#import "AFAVAssetCache.h"
#import "AFAssertion.h"
#import "AVAsset+Tracks.h"

id PlayerStatusContext;
NSString *STATUS_KEY = @"status";

@interface AFVideoPlayerView ()
- (void)assetVideoTrackLoaded:(AVAssetTrack *)videoTrack;
@end

@implementation AFVideoPlayerView
{
    bool observingPlayerItem;
}

-(id)initWithURL:(NSURL*)url
{
    AVAsset* asset = [[AFAVAssetCache sharedInstance] obtainAssetForURL:url];

    self = [self initWithAsset:asset];
    if(self){}
    return self;
}

-(id)initWithAsset:(AVAsset*)asset
{
    self = [self init];
    if(self)
    {
        playerItem = [[AVPlayerItem alloc] initWithAsset:asset];

        [asset beginLoadVideoTrackTo:self selector:@selector(assetVideoTrackLoaded:)];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
    }
    return self;
}

-(void)assetVideoTrackLoaded:(AVAssetTrack*)videoTrack
{
    NSLog(@"Track is %ix%i",(int)videoTrack.naturalSize.width, (int)videoTrack.naturalSize.height);

    self.playerItem = [AVPlayerItem playerItemWithAsset:videoTrack.asset];
    [self.playerItem addObserver:self forKeyPath:STATUS_KEY options:NSKeyValueObservingOptionNew context:&PlayerStatusContext];
    observingPlayerItem = YES;

    float
        aspectRatio     = videoTrack.naturalSize.width / videoTrack.naturalSize.height,
        preferredHeight = self.frame.size.width / aspectRatio;

    self.preferredSize = CGSizeMake(self.frame.size.width, preferredHeight );

    [self.superview setNeedsLayout];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];

    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
}

-(id)init
{
    self = [super init];
    if(self)
    {
        autoPlay = YES;
        observingPlayerItem = NO;
    }
    return self;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.player seekToTime:kCMTimeZero];
}

- (void)refresh
{
    AFAssertMainThread();

    if( (self.player.currentItem != nil) && ([self.player.currentItem status] == AVPlayerItemStatusReadyToPlay) )
    {
        self.playButton.enabled = YES;

        if(autoPlay)
        {
            [player play];
        }
    }
    else
    {
        self.playButton.enabled = NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == &PlayerStatusContext)
    {
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    playButton.center = self.center;
}


- (void)dealloc
{
    if(observingPlayerItem)
    {
        [self.playerItem removeObserver:self forKeyPath:STATUS_KEY];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [player release];
    [playerItem release];
    [playButton release];
    [super dealloc];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) [self refresh];
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)playerIn
{
    [(AVPlayerLayer *)[self layer] setPlayer:playerIn];
}

- (AVAsset *)asset { return playerItem.asset; }

@synthesize playerItem;
@synthesize playButton;

@end