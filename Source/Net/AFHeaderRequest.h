#import <Foundation/Foundation.h>
#import "AFBaseRequest.h"

@protocol AFRequestEndpoint;

@interface AFHeaderRequest : AFBaseRequest <AFRequest>
{
    NSDictionary                 *headers;
    NSObject <AFRequestEndpoint> *endpoint;
}

- (id)initWithURL:(NSURL *)URLIn endpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

@property(nonatomic, retain) NSObject <AFRequestEndpoint> *endpoint;
@property(nonatomic, retain) NSDictionary                 *headers;

@end
