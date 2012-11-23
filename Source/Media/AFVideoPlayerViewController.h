//
// Created by Chris Hatton on 14/10/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AFVideoPlayerView;

@interface AFVideoPlayerViewController : UIViewController
{
    AVPlayer            *player;
    AVPlayerItem        *playerItem;
    AFVideoPlayerView   *playerView;
    UIButton            *playButton;

    bool autoPlay;
}

- (id)initWithURL:(NSURL *)url;
- (id)initWithAsset:(AVAsset *)asset;
- (void)playerItemDidReachEnd:(NSNotification *)notification;
- (void)refresh;

@property (nonatomic, retain) AVPlayer          *player;
@property (nonatomic, retain) AVPlayerItem      *playerItem;
@property (nonatomic, retain) AFVideoPlayerView *playerView;
@property (nonatomic, retain) UIButton          *playButton;

@end