#import "AFObservable.h"
#import "AFRequest.h"

SEL
    AFRequestEventStarted,
    AFRequestEventProgressUpdated,
    AFRequestEventFinished,
    AFRequestEventCancel,
    AFRequestEventQueued,
    AFRequestEventReset,
    AFRequestEventSizePolled,
    AFRequestEventFailed;

@implementation AFRequest

+(void)initialize
{
    AFRequestEventStarted          = @selector(requestStarted:);                    //Params: AFRequest
    AFRequestEventProgressUpdated  = @selector(requestProgressUpdated:); //Params: NSNumber, AFRequest
    AFRequestEventFinished         = @selector(requestComplete:);                   //Params: AFRequest
    AFRequestEventCancel           = @selector(requestCancelled:);                  //Params: AFRequest
    AFRequestEventFailed           = @selector(requestFailed:);                     //Params: AFRequest
    AFRequestEventQueued           = @selector(handleRequest:queuedAt:);    //Params: AFRequest, NSNumber
    AFRequestEventReset            = @selector(handleRequestReset:);        //Params: AFRequest
    AFRequestEventSizePolled       = @selector(handleRequestSizePolled:);  //Params: AFRequest
}

@synthesize attempts, requiresLogin, URL, state, connection = connection;

- (id)initWithURL:(NSURL *)URLIn requiresLogin:(BOOL)requiresLoginIn
{
    if ((self = [self initWithURL:URLIn]))
    {
        requiresLogin = requiresLoginIn;
    }
    return self;
}

- (id)initWithURL:(NSURL *)URLIn
{
    if ( URLIn && (self = [super init]) )
    {
        URL             = [URLIn retain];
        state           = (AFRequestState) AFRequestStatePending;
        expectedBytes   = -1;
        receivedBytes   = 0;
        numberFormatter = [[NSNumberFormatter alloc] init];
        requiresLogin   = NO;
        attempts        = 0;
    }
    return self;
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn
{
    attempts++;
    return requestIn;
}

-(bool)isSuccessHTTPResponse
{
    return ( responseCode >= 200 ) && ( responseCode < 300 );
}


- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCodeIn
{
    responseCode = responseCodeIn;

    if([self isSuccessHTTPResponse])
    {
        [self setExpectedBytesFromHeader:headers isCritical:NO];
        state = (AFRequestState) AFRequestStateInProcess;
        [self notifyObservers:AFRequestEventStarted parameters:self,nil];
    }
    else
    {
        NSError *error = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:responseCode userInfo:nil];
        [self didFail:error];
        [error release];
    }
}

- (void)setExpectedBytesFromHeader:(NSDictionary *)header isCritical:(BOOL)critical;
{
    NSString *keyStr = [header valueForKey:@"Content-Length"];
    if (keyStr)
    {
        NSNumber *keyNum = [numberFormatter numberFromString:keyStr];
        if (keyNum)
        {
            expectedBytes = [keyNum intValue];
        }
        else if (critical)
        {
            [NSException raise:NSInternalInconsistencyException format:@"Couldn't parse content-length from header"];
        }
    }
    else if (critical)
    {
        //[NSException raise:NSInternalInconsistencyException format:@"Request had no Content-length in header! URL: %@", [URL absoluteString]];
    }
}

- (void)received:(NSData *)dataIn
{
    receivedBytes += [dataIn length];
    [self notifyObservers:AFRequestEventProgressUpdated parameters:self,nil];
}

- (void)didFinish
{
    state = AFRequestStateFulfilled;
    [self notifyObservers:AFRequestEventFinished parameters:self,nil];
}

- (void)didFail:(NSError *)error
{
    state = AFRequestStateFailed;
    [self notifyObservers:AFRequestEventFailed  parameters:self,nil];
}

- (void)cancel
{
    state = (AFRequestState) AFRequestStatePending;
    [connection cancel];
    [self notifyObservers:AFRequestEventCancel parameters:self,nil];
}

-(float)progress
{
    float progress = expectedBytes > 0 ? (float) receivedBytes / (float) expectedBytes : 0;
    return progress;
}

- (BOOL)complete
{
    return receivedBytes >= expectedBytes;
}

- (NSString *)          actionDescription { return nil;           }
- (int)                 attempts          { return attempts;      }
- (int)                 receivedBytes     { return receivedBytes; }
- (int)                 expectedBytes     { return expectedBytes; }
- (int)                 responseCode      { return responseCode;  }

-(void)dealloc
{
    [numberFormatter    release];
    [connection         release];
    [URL                release];
    [super              dealloc];
}

@end