
#import "AFObservable.h"
#import "AFRequest.h"
#import "AFRequest+Protected.h"

SEL
    AFRequestEventStarted,
    AFRequestEventProgressUpdated,
    AFRequestEventFinished,
    AFRequestEventCancel,
    AFRequestEventQueued,
    AFRequestEventReset,
    AFRequestEventWillPollSize,
    AFRequestEventDidPollSize,
    AFRequestEventFailed;

@implementation AFRequest
{
    int
        expectedBytes,
        receivedBytes;
}

+(void)initialize
{
    AFRequestEventStarted          = @selector(requestStarted:);            //Params: AFRequest
    AFRequestEventProgressUpdated  = @selector(requestProgressUpdated:);    //Params: AFRequest
    AFRequestEventFinished         = @selector(requestComplete:);           //Params: AFRequest
    AFRequestEventCancel           = @selector(requestCancelled:);          //Params: AFRequest
    AFRequestEventFailed           = @selector(requestFailed:);             //Params: AFRequest
    AFRequestEventQueued           = @selector(handleRequest:queuedAt:);    //Params: AFRequest, NSNumber
    AFRequestEventReset            = @selector(handleRequestReset:);        //Params: AFRequest
    AFRequestEventWillPollSize     = @selector(handleRequestWillPollSize:); //Params: AFRequest
    AFRequestEventDidPollSize      = @selector(handleRequestDidPollSize:);  //Params: AFRequest
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

- (int)expectedBytes
{
    return expectedBytes;
}

-(void)setExpectedBytes:(int)expectedBytesIn
{
    expectedBytes = expectedBytesIn;
}

- (id)initWithURL:(NSURL *)URLIn
{
    if ( URLIn && (self = [self init]) )
    {
        URL             = [URLIn retain];
        state           = (AFRequestState) AFRequestStatePending;
        expectedBytes   = -1;
        self.receivedBytes = 0;
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

- (void)willReceiveWithHeaders:(NSDictionary *)header responseCode:(int)responseCodeIn
{
    responseCode = responseCodeIn;

    if([self isSuccessHTTPResponse])
    {
        int size = [self contentLengthFromHeader:header];
        self.expectedBytes = size;
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

- (int)contentLengthFromHeader:(NSDictionary *)header
{
    NSString *stringValue = [header valueForKey:@"Content-Length"];
    if (stringValue)
    {
        NSNumber *keyNum = [numberFormatter numberFromString:stringValue];
        if (keyNum)
        {
            return [keyNum intValue];
        }
    }
    return -1;
}

-(NSRange)contentRangeFromHeader:(NSDictionary*)header
{
    NSString *rangeString = [header valueForKey:@"Content-Range"];

    NSRange range;
    
    if(rangeString)
    {
        NSArray *rangeComponents = [rangeString componentsSeparatedByString:@"-"];
        if( rangeComponents.count == 2 )
        {
            NSString
                *startString = rangeComponents[0],
                *endString   = rangeComponents[1];

            int location, length;

            if(startString.length>0)
            {
                location = [[numberFormatter numberFromString:startString] intValue];
            }
            else location = 0;

            if(endString.length>0)
            {
                length = [[numberFormatter numberFromString:endString] intValue] - location;
            }
            else length = expectedBytes - location;

            range = NSMakeRange((NSUInteger)location, (NSUInteger)length);
        }
        else range = NSMakeRange(NSNotFound,0);
    }
    else range = NSMakeRange(NSNotFound,0);

    return range;
}

- (void)received:(NSData *)dataIn
{
    self.receivedBytes += [dataIn length];
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
    //return receivedBytes >= expectedBytes;
}

- (NSString *)          actionDescription { return nil;           }
- (int)                 attempts          { return attempts;      }

- (int) receivedBytes { return receivedBytes; }
- (void)setReceivedBytes:(int)receivedBytesIn
{
    receivedBytes = receivedBytesIn;
    [self notifyObservers:AFRequestEventProgressUpdated parameters:self,nil];
}

- (int)                 responseCode      { return responseCode;  }

-(void)dealloc
{
    [numberFormatter    release];
    [connection         release];
    [URL                release];
    [super              dealloc];
}

@end