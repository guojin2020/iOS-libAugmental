#import "AFCachingAudioPlayer.h"

#if TARGET_IPHONE_SIMULATOR
#else
static NSMutableDictionary* sounds;
#endif

@implementation AFCachingAudioPlayer

+ (void)playSound:(NSString *)name
{
#if TARGET_IPHONE_SIMULATOR
#else
	if(!sounds) sounds = [[NSMutableDictionary alloc] init];
	AVAudioPlayer* player= (AVAudioPlayer*)[sounds objectForKey:name];
	if(!player)
	{
		NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
		NSError* e;
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] AFSessionStateError:&e];
		[sounds setObject:player forKey:name];
		[player play];
		[player release];
	}
	else
	{
		[player play];
	}
	#endif
}

@end
