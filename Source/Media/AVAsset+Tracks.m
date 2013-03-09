//
// Created by augmental on 26/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#define TRACKS_KEY @"tracks"

#import "AVAsset+Tracks.h"

@implementation AVAsset (Tracks)

-(void)beginLoadVideoTrackTo:(id)target selector:(SEL)callbackSelector
{
    void (^handleTracksLoaded)() = ^
    {
        NSError *error;
        AVKeyValueStatus status = [self statusOfValueForKey:TRACKS_KEY error:&error];

        AVAssetTrack *videoTrack = NULL;

        if( status == AVKeyValueStatusLoaded )
        {
            for(AVAssetTrack* track in self.tracks)
            {
                if([track.mediaType isEqualToString:AVMediaTypeVideo])
                {
                    videoTrack = track;
                    break;
                }
            }
        }

        [target performSelector:callbackSelector withObject:videoTrack];
    };

    NSArray *keys = [[NSArray alloc] initWithObjects:TRACKS_KEY,nil];
    [self loadValuesAsynchronouslyForKeys:keys completionHandler:handleTracksLoaded];
    [keys release];
}

@end