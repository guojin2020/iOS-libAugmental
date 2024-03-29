
#import "AFHeaderRequest.h"

#import "AFRequestEndpoint.h"
#import "AFLog.h"

@implementation AFHeaderRequest

- (id)initWithURL:(NSURL *)URLIn endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    NSAssert(endpointIn, @"No endpoint was specified for a header request.");

    if ((self = [super initWithURL:URLIn]))
    {
        self.endpoint = endpointIn;
    }
    return self;
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn
{
    AFLogPosition();

    requestIn = [super willSendURLRequest:requestIn];
    [requestIn setHTTPMethod:@"HEAD"];
    return requestIn;
}

- (void)willReceiveWithHeaders:(NSDictionary *)headersIn responseCode:(int)responseCodeIn
{
    self.headers = headersIn;
    [super willReceiveWithHeaders:headersIn responseCode:responseCodeIn];
}

- (void)didFinish
{
    [super didFinish];
    [endpoint request:self returnedWithData:headers];
}

-(void)didFail:(NSError *)error
{
    [super didFail:error];
    [endpoint requestFailed:self withError:error];
}

- (NSString *)actionDescription
{
    return @"Determining download size";
}


@synthesize endpoint, headers;

@end
