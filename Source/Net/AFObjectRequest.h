//Represents a request for data from a URL, whose completion will trigger the specified callback

#import <Foundation/Foundation.h>
#import "AFJSONRequest.h"
//#import "AFRequest.h"
//#import "CJSONDeserializer.h"

//@class AFSession;
@protocol AFRequestEndpoint;

#define SHOW_SERVER_DEBUG

@interface AFObjectRequest : AFJSONRequest <AFRequest>
{
}

- (id)initWithURL:(NSURL *)URLIn AFWriteableObjects:(NSArray *)postObjects endpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

@end
