//Represents a request for data from a URL, whose completion will trigger the specified callback

#import "AFRequest.h"

@class AFSession;
@class CJSONDeserializer;
@class CJSONSerializer;

@protocol AFRequestEndpoint;

@interface AFJSONRequest : AFRequest
{
    NSObject <AFRequestEndpoint> *endpoint;
    NSMutableData                *responseDataBuffer;
    NSData                       *postData;
    NSDictionary                 *returnedDictionary;
}

+ (CJSONDeserializer *)jsonDeserializer;
+ (CJSONSerializer *)jsonSerializer;
- (NSData *)receivedData;
- (NSData *)postData;
- (NSString *)newPostDataString;

- (id)initWithURL:(NSURL *)URLIn endpoint:(NSObject <AFRequestEndpoint> *)endpointIn;
- (id)initWithURL:(NSURL *)URLIn Dictionary:(NSDictionary *)postDictionary endpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

@property(nonatomic, retain, readonly) NSDictionary *returnedDictionary;

@end
