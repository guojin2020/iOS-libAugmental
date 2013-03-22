
#import "AFObservable.h"
#import "AFRequest.h"
#import "AFRequest+Protected.h"
#import "AFFileUtils.h"
#import "AFParseHTTPContentRange.h"

SEL
    AFRequestEventStarted,
    AFRequestEventProgressUpdated,
    AFRequestEventFinished,
    AFRequestEventCancel,
    AFRequestEventQueued,
    AFRequestEventWillPollSize,
    AFRequestEventDidPollSize,
    AFRequestEventFailed;

@implementation AFRequest
{
    int
        expectedBytes,
        receivedBytes,
        queuePosition;

    AFRequestState state;
}

+(void)initialize
{
    AFRequestEventStarted          = @selector(requestStarted:);            //Params: AFRequest
    AFRequestEventProgressUpdated  = @selector(requestProgressUpdated:);    //Params: AFRequest
    AFRequestEventFinished         = @selector(requestComplete:);           //Params: AFRequest
    AFRequestEventCancel           = @selector(requestCancelled:);          //Params: AFRequest
    AFRequestEventFailed           = @selector(requestFailed:withError:);   //Params: AFRequest, NSError
    AFRequestEventQueued           = @selector(handleRequest:queuedAt:);    //Params: AFRequest, NSNumber
    AFRequestEventWillPollSize     = @selector(handleRequestWillPollSize:); //Params: AFRequest
    AFRequestEventDidPollSize      = @selector(handleRequestDidPollSize:);  //Params: AFRequest
}

@synthesize attempts, requiresLogin, URL, state, connection = connection;

-(id)initWithURL:(NSURL *)URLIn requiresLogin:(BOOL)requiresLoginIn
{
    NSAssert(URLIn, NSInvalidArgumentException);

    self = [self initWithURL:URLIn];
    if( self )
    {
        requiresLogin = requiresLoginIn;
    }
    return self;
}

-(id)initWithURL:(NSURL *)URLIn
{
    NSAssert(URLIn, NSInvalidArgumentException);

    self = [self init];
    if( self )
    {
        URL = [URLIn retain];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if( self )
    {
        self.error      = NULL;
        receivedBytes   = 0;
        state           = AFRequestStateIdle;
        expectedBytes   = -1;
        numberFormatter = [[NSNumberFormatter alloc] init];
        requiresLogin   = NO;
        attempts        = 0;
    }
    return self;
}

-(void)setState:(AFRequestState)stateIn
{
    if( state!=stateIn )
    {
        state = stateIn;
        switch( state )
        {
            case AFRequestStateIdle:        [self notifyObservers:AFRequestEventCancel          parameters:self,nil];       break;
            case AFRequestStateQueued:      [self notifyObservers:AFRequestEventQueued          parameters:self,[NSNumber numberWithInt:queuePosition],nil]; break;
            case AFRequestStateInProcess:   [self notifyObservers:AFRequestEventProgressUpdated parameters:self,nil];       break;
            case AFRequestStateFulfilled:   [self notifyObservers:AFRequestEventFinished        parameters:self,nil];       break;
            case AFRequestStateFailed:      [self notifyObservers:AFRequestEventFailed          parameters:self,self.error,nil]; break;
        }
    }
}

-(int)expectedBytes { return expectedBytes; }
-(void)setExpectedBytes:(int)expectedBytesIn
{
    expectedBytes = expectedBytesIn;
    [self notifyObservers:AFRequestEventProgressUpdated parameters:NULL];
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

- (void)willReceiveWithHeaders:(NSDictionary *)header responseCode:(int)responseCodeIn
{
    responseCode = responseCodeIn;

    if([self isSuccessHTTPResponse])
    {
        AFRangeInfo* rangeInfo = CreateAFRangeInfoFromHTTPHeaders(header);

        self.expectedBytes = rangeInfo->contentTotal;
        self.state = AFRequestStateInProcess;
        [self notifyObservers:AFRequestEventStarted parameters:self,nil];

        free(rangeInfo);
    }
    else
    {
        NSError *httpError = [[NSError alloc] initWithDomain:NSNetServicesErrorDomain code:responseCode userInfo:nil];
        [self didFail:httpError];
        [httpError release];
    }
}

- (void)requestWasQueuedAtPosition:(NSUInteger)queuePositionIn
{
    queuePosition = queuePositionIn;
    self.state = AFRequestStateQueued;
}

- (void)received:(NSData *)dataIn
{
    self.state = AFRequestStateInProcess;
    self.receivedBytes += [dataIn length];
}

- (void)didFinish
{
    self.state = AFRequestStateFulfilled;
}

- (void)didFail:(NSError *)errorIn;
{
    self.error = errorIn;
    self.state = AFRequestStateFailed;
}

- (void)cancel
{
    self.state = AFRequestStateIdle;
    [connection cancel];
}

-(float)progress
{
    float progress = self.expectedBytes > 0 ? (float) self.receivedBytes / (float) self.expectedBytes : 0;
    return progress;
}

- (BOOL)complete
{
    switch(state)
    {
        case AFRequestStateFulfilled:
        case AFRequestStateFailed:
           return YES;

        default:
           return NO;
    }
}

- (NSString*) actionDescription { return nil;      }
- (int)       attempts          { return attempts; }

- (int) receivedBytes { return receivedBytes; }
- (void)setReceivedBytes:(int)receivedBytesIn
{
    receivedBytes = receivedBytesIn;
    [self notifyObservers:AFRequestEventProgressUpdated parameters:self,nil];
}

- (int)responseCode { return responseCode;  }

-(void)dealloc
{
    [_error              release];
    [numberFormatter    release];
    [connection         release];
    [URL                release];
    [super              dealloc];
}

@end