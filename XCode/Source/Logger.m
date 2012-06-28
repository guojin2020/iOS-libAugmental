
#import "Logger.h"

static BOOL logging = YES;
static int logLevel = 6;

@implementation Logger

+(void)log:(NSString*)logString
{
	if(logging)
	{
		NSLog(@"%@",logString);
	}
}

+(void)log:(NSString*)logString level:(int)logLevelIn
{
	if(logging && logLevel>=logLevelIn)
	{
		NSLog(@"%@",logString);
	}
}

+(int)logLevel
{
	return logLevel;
}

@end
