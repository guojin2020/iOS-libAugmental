//Represents a request for data from a URL, whose completion will trigger the specified callback

#import <Foundation/Foundation.h>
#import "AFJSONRequest.h"

@protocol AFRequestEndpoint;

#define SHOW_SERVER_DEBUG

DEPRECATED_ATTRIBUTE
@interface AFObjectRequest : AFJSONRequest
{
}

- (id)initWithURL:(NSURL *)URLIn AFWriteableObjects:(NSArray *)postObjects endpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

@end
