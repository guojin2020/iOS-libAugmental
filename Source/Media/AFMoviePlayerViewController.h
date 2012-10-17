//
// Created by augmental on 17/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class MPMoviePlayerController;


@interface AFMoviePlayerViewController : UIViewController
{
    MPMoviePlayerController *player;
}

-(id)initWithVideoURL:(NSURL *)videoURL;

@end