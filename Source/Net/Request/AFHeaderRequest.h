
#import <Foundation/Foundation.h>

#import "AFRequest.h"

@protocol AFRequestEndpoint;

@interface AFHeaderRequest : AFRequest
{
    NSDictionary                 *headers;
    NSObject <AFRequestEndpoint> *endpoint;
}

- (id)initWithURL:(NSURL *)URLIn endpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

@property(nonatomic, strong) NSObject <AFRequestEndpoint> *endpoint;
@property(nonatomic, strong) NSDictionary                 *headers;

@end
