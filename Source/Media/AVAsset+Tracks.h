//
// Created by augmental on 26/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAsset (Tracks)

-(void)beginLoadVideoTrackTo:(id)target selector:(SEL)callbackSelector;

@end