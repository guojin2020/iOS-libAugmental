#import <Foundation/Foundation.h>

#if DEBUG
#define AFLogMsg(M) NSLog(@"[%@] %@ -> %@ - '%@'", [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd), M )
#define AFLogPosition( ) NSLog(@"[%@] %@ -> %@", [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd) )
#else
#define AFLogPosition()
#endif

@interface AFLogger : NSObject {}

+(void)log:(NSString *)logString;
+(void)log:(NSString *)logString level:(int)logLevelIn;
+(int)logLevel;

@end
