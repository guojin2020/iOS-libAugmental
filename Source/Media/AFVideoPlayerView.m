//
// Created by Chris Hatton on 14/10/2012.
// Contact: christopherhattonuk@gmail.com
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