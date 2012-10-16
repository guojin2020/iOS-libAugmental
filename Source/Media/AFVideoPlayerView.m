//
// Created by augmental on 14/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFVideoPlayerView.h"

@implementation AFVideoPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}
- (AVPlayer*)player
{
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
@end