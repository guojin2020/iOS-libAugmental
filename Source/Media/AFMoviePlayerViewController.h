//
// Created by Chris Hatton on 17/10/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>

@class MPMoviePlayerController;


@interface AFMoviePlayerViewController : UIViewController
{
    MPMoviePlayerController *player;
}

-(id)initWithVideoURL:(NSURL *)videoURL;

@end