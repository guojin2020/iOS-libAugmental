#import <Foundation/Foundation.h>

#import "AFRequest.h"

@protocol AFRequestEndpoint;

@interface AFImmediateRequest : AFRequest
{
    NSObject<AFRequestEndpoint> *endpoint;
    NSMutableData               *responseDataBuffer;
    NSData                      *postData;
}

-(id)initWithURL:(NSURL *)URLIn
        endpoint:(NSObject<AFRequestEndpoint> *)endpoint;

-(id)initWithURL:(NSURL *)URLIn
        postData:(NSData *)postDataIn
        endpoint:(NSObject<AFRequestEndpoint> *)endpoint;

@end
