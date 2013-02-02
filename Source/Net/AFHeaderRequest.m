
#import "AFHeaderRequest.h"

#import "AFRequestEndpoint.h"
#import "AFLogger.h"

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
    [super willSendURLRequest:requestIn];
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

- (NSString *)actionDescription
{
    return @"Determining download size";
}

- (void)dealloc
{
    [endpoint release];
    [headers release];
    [super dealloc];
}

@synthesize endpoint, headers;

@end
