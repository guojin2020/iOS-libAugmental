#import <Foundation/Foundation.h>

#ifdef DEBUG

#define AFLog( s, ... ) NSLog( s, ##__VA_ARGS__ )

#define AFLogPosition_0()  NSLog(@"[%@] %@ -> %@",         [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd) )
#define AFLogPosition_1(m) NSLog( @"[%@] %@ -> %@ - '%@'", [NSThread currentThread], NSStringFromClass([self class]), NSStringFromSelector(_cmd), (m), nil)

#define AFLogPosition_X(x,m,FUNC, ...) FUNC

#define AFLogPosition(...) AFLogPosition_X(,##__VA_ARGS__, AFLogPosition_1(__VA_ARGS__), AFLogPosition_0(__VA_ARGS__))

#else

#define AFLog( s, ... )
#define AFLogPosition( ... )

#endif
