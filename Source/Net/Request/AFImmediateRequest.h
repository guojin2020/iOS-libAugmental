#import <Foundation/Foundation.h>

#import "AFRequest.h"

@interface AFImmediateRequest : AFRequest
{
    NSObject        *callbackObject;
    SEL             callbackSelector;
    NSMutableData   *responseDataBuffer;
    NSData          *postData;
}

- (id)initWithURL:(NSURL *)URLIn callbackObject:(NSObject *)callbackObjectIn callbackSelector:(SEL)callbackSelectorIn;

- (id)initWithURL:(NSURL *)URLIn postData:(NSData *)postDataIn callbackObject:(NSObject *)callbackObjectIn callbackSelector:(SEL)callbackSelectorIn;

@end
