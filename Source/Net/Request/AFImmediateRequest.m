
#import "AFImmediateRequest.h"

#import "AFRequestEndpoint.h"

@implementation AFImmediateRequest

-(id)initWithURL:(NSURL *)URLIn
        endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    NSAssert(endpointIn, NSInvalidArgumentException );

    if ((self = [super initWithURL:URLIn]))
    {
        endpoint           = [endpointIn retain];
        responseDataBuffer = [[NSMutableData data] retain];
    }
    return self;
}

-(id)initWithURL:(NSURL *)URLIn
        postData:(NSData *)postDataIn
		endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    self = [self initWithURL:URLIn endpoint:endpointIn];
    if( self )
    {
        postData = [postDataIn retain];
    }
    return self;
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn
{
    requestIn = [super willSendURLRequest:requestIn];

    if (postData)
    {
        [requestIn setHTTPMethod:@"POST"];
        [requestIn setHTTPBody:postData];
    }
    return requestIn;
}

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCodeIn
{
    [super willReceiveWithHeaders:headers responseCode:responseCodeIn];
    [responseDataBuffer setLength:0];
}

- (void)received:(NSData *)dataIn
{
    [super received:dataIn];
    [responseDataBuffer appendData:dataIn];
}

- (NSString *)actionDescription
{return @"Getting file";}

- (void)didFinish
{
    [super didFinish];

    [endpoint request:self returnedWithData:responseDataBuffer];
}

- (void)dealloc
{
    [endpoint           release];
    [responseDataBuffer release];
    [postData           release];

    [super dealloc];
}

@end
