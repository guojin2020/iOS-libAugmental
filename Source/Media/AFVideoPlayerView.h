//
// Created by Chris Hatton on 14/10/2012.
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AFConstrainedView.h"

@class AFVideoPlayerView;

@interface AFVideoPlayerView : AFConstrainedView
{
    AVPlayer     *player;
    AVPlayerItem *playerItem;
    UIButton     *playButton;

    bool autoPlay;
}

- (id)initWithURL:(NSURL *)url;
- (id)initWithAsset:(AVAsset *)asset;
- (void)playerItemDidReachEnd:(NSNotification *)notification;
- (void)refresh;

@property (nonatomic, strong)   AVPlayer     *player;
@property (nonatomic, strong)   AVPlayerItem *playerItem;
@property (nonatomic, strong)   UIButton     *playButton;
@property (weak, nonatomic, readonly) AVAsset      *asset;

@end