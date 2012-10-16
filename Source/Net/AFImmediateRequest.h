#import <Foundation/Foundation.h>
#import "AFBaseRequest.h"
#import "AFRequest.h"

@interface AFImmediateRequest : AFBaseRequest <AFRequest>
{
    NSObject *callbackObject;
    SEL callbackSelector;
    NSMutableData *responseDataBuffer;

    NSData *postData;
    NSURLConnection *connection;
}

- (id)initWithURL:(NSURL *)URLIn callbackObject:(NSObject *)callbackObjectIn callbackSelector:(SEL)callbackSelectorIn;

- (id)initWithURL:(NSURL *)URLIn postData:(NSData *)postDataIn callbackObject:(NSObject *)callbackObjectIn callbackSelector:(SEL)callbackSelectorIn;

@end
