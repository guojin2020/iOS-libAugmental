
#import "AFObservable.h"
#import "AFImmediateRequest.h"

@implementation AFImmediateRequest

- (id)initWithURL:(NSURL *)URLIn callbackObject:(NSObject *)callbackObjectIn callbackSelector:(SEL)callbackSelectorIn
{
    NSAssert(callbackObjectIn && callbackSelectorIn, @"Invalid parameters initing %@", [self class]);

    if ((self = [super initWithURL:URLIn]))
    {
        callbackObject = [callbackObjectIn retain];
        [callbackObject retain];
        callbackSelector   = callbackSelectorIn;
        responseDataBuffer = [[NSMutableData data] retain];
    }
    return self;
}

- (id)initWithURL:(NSURL *)URLIn postData:(NSData *)postDataIn callbackObject:(NSObject *)callbackObjectIn callbackSelector:(SEL)callbackSelectorIn
{
    if ((self = [self initWithURL:URLIn callbackObject:callbackObjectIn callbackSelector:callbackSelectorIn]))
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
    if ((state = (AFRequestState) AFRequestStateInProcess))
    {[responseDataBuffer appendData:dataIn];}
}

- (NSString *)actionDescription
{return @"Getting file";}

- (void)didFinish
{
    [super didFinish];
    [callbackObject performSelector:callbackSelector withObject:responseDataBuffer];
}

- (void)dealloc
{
    [callbackObject release];
    [callbackObject release];
    [responseDataBuffer release];
    [postData release];
    [super dealloc];
}

//@dynamic connection, URL, state, requiresLogin, attempts;

@end
