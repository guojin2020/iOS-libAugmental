#import <Foundation/Foundation.h>

#if DEBUG
#define AFLogPosition() NSLog(@"[%@] %@ -> %@", [[NSThread currentThread] name], NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#else
#define AFLogPosition()
#endif

@interface AFLogger : NSObject {}

+(void)log:(NSString *)logString;
+(void)log:(NSString *)logString level:(int)logLevelIn;
+(int)logLevel;

@end
