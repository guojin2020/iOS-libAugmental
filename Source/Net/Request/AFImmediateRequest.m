
#import "AFImmediateRequest.h"
#import "AFRequestEndpoint.h"

@implementation AFImmediateRequest

-(id)initWithURL:(NSURL *)URLIn
        endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    NSAssert( endpointIn, NSInvalidArgumentException );
    [self release];

    self = [[AFEndpointImmediateRequest alloc] initWithURL:URLIn
                                                  endpoint:endpointIn];
    if(self)
    {
        [self commonInit];
    }
    return self;
}

-(id)initWithURL:(NSURL *)URLIn
         handler:(ResponseHandler)endpointIn
{
    NSAssert( endpointIn, NSInvalidArgumentException );
    [self release];

    self = [[AFBlocksImmediateRequest alloc] initWithURL:URLIn
                                                endpoint:endpointIn];
    if(self)
    {
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    responseDataBuffer = [[NSMutableData data] retain];
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn
{
    requestIn = [super willSendURLRequest:requestIn];

    if (_postData)
    {
        [requestIn setHTTPMethod:@"POST"];
        [requestIn setHTTPBody:_postData];
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
{
    return @"Getting file";
}

- (void)dealloc
{
    [responseDataBuffer release];
    self.postData = nil;
    [super dealloc];
}

@end

@implementation AFEndpointImmediateRequest
{
    NSObject<AFRequestEndpoint> *endpoint;
}

-(id)initWithURL:(NSURL*)URLIn
        endpoint:(NSObject<AFRequestEndpoint>*)endpointIn
{
    self = [super initWithURL:URLIn];
    if(self)
    {
        endpoint = [endpointIn retain];
    }
    return self;
}

- (void)didFinish
{
    [super didFinish];

    [endpoint request:self returnedWithData:responseDataBuffer];
}

-(void)dealloc
{
    [endpoint release];
    [super dealloc];
}

@end

@implementation AFBlocksImmediateRequest
{
    ResponseHandler endpoint;
}

-(id)initWithURL:(NSURL*)URLIn
         handler:(ResponseHandler)endpointIn
{
    self = [super initWithURL:URLIn];
    if(self)
    {
        endpoint = endpointIn;
    }
    return self;
}

- (void)didFinish
{
    [super didFinish];

    endpoint( responseDataBuffer );
}

@end