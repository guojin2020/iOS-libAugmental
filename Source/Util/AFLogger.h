#import <Foundation/Foundation.h>

#define AFLogPosition() NSLog(@"[%@] %@ -> %@", [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd) )
#define AFLogMsg(m) NSLog( @"[%@] %@ -> %@ - '%@'", [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd), (m), nil)

#if DEBUG

#else
#define AFLogPosition()
#endif

@interface AFLogger : NSObject {}

+(void)log:(NSString *)logString;
+(void)log:(NSString *)logString level:(int)logLevelIn;
+(int)logLevel;

@end
