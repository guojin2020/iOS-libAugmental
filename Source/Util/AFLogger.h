#import <Foundation/Foundation.h>

#define AFLogPosition_0()  NSLog(@"[%@] %@ -> %@",         [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd) )
#define AFLogPosition_1(m) NSLog( @"[%@] %@ -> %@ - '%@'", [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd), (m), nil)

#define AFLogPosition_X(x,m,FUNC, ...) FUNC

#define AFLogPosition(...) AFLogPosition_X(,##__VA_ARGS__,\
                           AFLogPosition_1(__VA_ARGS__),\
                           AFLogPosition_0(__VA_ARGS__))

#if DEBUG

#else
#define AFLogPosition()
#endif

@interface AFLogger : NSObject {}

+(void)log:(NSString *)logString;
+(void)log:(NSString *)logString level:(int)logLevelIn;
+(int)logLevel;

@end
