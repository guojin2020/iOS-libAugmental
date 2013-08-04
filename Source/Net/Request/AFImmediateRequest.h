
#import "AFRequest.h"

typedef void (^ResponseHandler)(NSData*);

@protocol AFRequestEndpoint;

@interface AFImmediateRequest : AFRequest
{
    NSMutableData *responseDataBuffer;
}

-(id)initWithURL:(NSURL *)URLIn
        endpoint:(NSObject<AFRequestEndpoint>*)endpoint;

-(id)initWithURL:(NSURL *)URLIn
         handler:(ResponseHandler)responseHandler;

@property (nonatomic,strong) NSData* postData;

@end

@interface AFEndpointImmediateRequest : AFImmediateRequest
@end

@interface AFBlocksImmediateRequest : AFImmediateRequest
@end