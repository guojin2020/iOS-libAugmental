
#import "UniversalMoviePlayer.h"
#import "AFImmediateRequest.h"


#import "AFUtil.h"

static UniversalMoviePlayer* sharedInstance = nil;

@interface UniversalMoviePlayer()

//-(void)readyPlayer;
//-(void)moviePreloadDidFinish:(NSNotification*)notification;
//-(void)moviePlayerLoadStateChanged:(NSNotification*)notification;

@end

@implementation UniversalMoviePlayer

+(UniversalMoviePlayer*)sharedInstance
{
	if(!sharedInstance) sharedInstance = [[UniversalMoviePlayer alloc] init];
	return sharedInstance;
}

-(void)playVideo:(NSURL*)url comingFromViewController:(UIViewController*)videoOverviewViewControllerIn;
{
    moviePlayer = [[[CustomMoviePlayerViewController alloc] initWithURL:url] autorelease];

    // Show the movie player as modal
    [videoOverviewViewControllerIn presentModalViewController:moviePlayer animated:YES];

    // Prep and play the movie
    [moviePlayer readyPlayer]; 
}

/*
-(void)playVideo:(NSURL*)url comingFromViewController:(UIViewController*)videoOverviewViewControllerIn;
{
	self.modalParentViewController = videoOverviewViewControllerIn;
	modalParentViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	if([AFUtil is32OrLater]) //Check for SDK level >=3.2
	{
        MPMoviePlayerController* mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        
        // May help to reduce latency
        [mp prepareToPlay];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayerLoadStateChanged:) 
                                                     name:MPMoviePlayerLoadStateDidChangeNotification 
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(movieDidExitFullscreen:)
													 name:MPMoviePlayerPlaybackDidFinishNotification
												   object:[(MPMoviePlayerViewController*)playerViewController moviePlayer]];
        
        
        //NSLog(@"iPhone 4 play");
        
		if(playerViewController) [playerViewController release];
		playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
		
		playerViewController.modalTransitionStyle       = UIModalTransitionStyleCrossDissolve;
		modalParentViewController.modalTransitionStyle  = UIModalTransitionStyleCrossDissolve;
		
		[modalParentViewController presentModalViewController:playerViewController animated:YES];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(movieDidExitFullscreen:)
													 name:MPMoviePlayerPlaybackDidFinishNotification
												   object:[(MPMoviePlayerViewController*)playerViewController moviePlayer]];
         
    }
	else //SDK level <3.2
	{
        //NSLog(@"iPhone 3.1.3 play");
        
		self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
		
		[playerController setFullscreen:YES];
		[playerController play];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(moviePlayerDidFinish:)
													 name:MPMoviePlayerPlaybackDidFinishNotification
												   object:playerController];
	}
	[playerController autorelease];
}
*/

/*
-(void)readyPlayer
{
    mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    // For 3.2 devices and above
    if ([mp respondsToSelector:@selector(loadState)]) 
    {
        // Set movie player layout
        [mp setControlStyle:MPMovieControlStyleFullscreen];
        [mp setFullscreen:YES];
        
        // May help to reduce latency
        [mp prepareToPlay];
        
        // Register that the load state changed (movie is ready)
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePlayerLoadStateChanged:) 
                                                     name:MPMoviePlayerLoadStateDidChangeNotification 
                                                   object:nil];
    }  
    else
    {
        // Register to receive a notification when the movie is in memory and ready to play.
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(moviePreloadDidFinish:) 
                                                     name:MPMoviePlayerContentPreloadDidFinishNotification 
                                                   object:nil];
    }
    
    // Register to receive a notification when the movie has finished playing. 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:nil];
}

-(void)moviePreloadDidFinish:(NSNotification*)notification 
{
    // Remove observer
    [[NSNotificationCenter 	defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerContentPreloadDidFinishNotification
     object:nil];
    
    // Play the movie
    [mp play];
}

-(void)moviePlayerLoadStateChanged:(NSNotification*)notification 
{
    // Unless state is unknown, start playback
    if ([mp loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter defaultCenter] 
         removeObserver:self
         name:MPMoviePlayerLoadStateDidChangeNotification 
         object:nil];
        
        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        
        // Rotate the view for landscape playback
        [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
        [[self view] setCenter:CGPointMake(160, 240)];
        [[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
        
        // Set frame of movie player
        [[mp view] setFrame:CGRectMake(0, 0, 480, 320)];
        
        // Add movie player as subview
        [[self view] addSubview:[mp view]];   
        
        // Play the movie
        [mp play];
    }
}


-(void)setPlayerController:(MPMoviePlayerController *)playerControllerIn
{
	MPMoviePlayerController* oldPlayerController = playerController;
	playerController = [playerControllerIn retain];
	[oldPlayerController stop];
	[oldPlayerController autorelease];
}

-(void) movieDidExitFullscreen:(NSNotification*) aNotification
{
	MPMoviePlayerController *player = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	[player pause];
	[player stop];
	
	[modalParentViewController dismissModalViewControllerAnimated:YES];
	[player.view removeFromSuperview];
	//[player autorelease];
	player = nil;
}

-(void) moviePlayerDidFinish:(NSNotification*) aNotification
{
	MPMoviePlayerController *player = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	self.playerController = nil;
}
 */

//@synthesize modalParentViewController,playerViewController,playerController;

@end
