//
// Created by augmental on 14/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AFVideoPlayerView;

@interface AFVideoPlayerViewController : UIViewController
{
    AVPlayer            *player;
    AVPlayerItem        *playerItem;
    AFVideoPlayerView   *playerView;
}

@property (nonatomic, retain) AVPlayer          *player;
@property (nonatomic, retain) AVPlayerItem      *playerItem;
@property (nonatomic, retain) AFVideoPlayerView *playerView;

@property (nonatomic, retain) UIButton *playButton;

- (void)loadAssetFromFile;
- (void)play;

- (id)initWithURL:(NSURL *)url;
- (id)initWithAsset:(AVAsset *)asset;

- (void)playerItemDidReachEnd:(NSNotification *)notification;

- (void)refresh;

@end