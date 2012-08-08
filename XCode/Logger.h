
#import <Foundation/Foundation.h>

@interface Logger : NSObject
{
}

+(void)log:(NSString*)logString;
+(void)log:(NSString*)logString level:(int)logLevelIn;

+(int)logLevel;

@end
