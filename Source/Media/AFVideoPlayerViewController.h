//
// Created by Chris Hatton on 17/01/2013
// Contact: christopherhattonuk@gmail.com
//

#import <Foundation/Foundation.h>

@class AFVideoPlayerView;
@class AVAsset;

@interface AFVideoPlayerViewController : UIViewController
{
	AFVideoPlayerView* videoPlayerView;
}

- (id)initWithAsset:(AVAsset *)assetIn;
- (id)initWithURL:(NSURL *)urlIn;

@property (weak, nonatomic, readonly) AVPlayer* player;

@end