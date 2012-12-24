#import "AFBaseRequest.h"

@implementation AFBaseRequest

@synthesize attempts, requiresLogin, URL, state;

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
    if (URLIn && (self = [super init]))
    {
        URL   = [URLIn retain];
        state = (AFRequestState) AFRequestStatePending;
        expectedBytes = -1;
        receivedBytes = 0;
        numberFormatter = [[NSNumberFormatter alloc] init];
        observers       = [[NSMutableSet alloc] init];
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

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCodeIn
{
    responseCode = responseCodeIn;
    [self setExpectedBytesFromHeader:headers isCritical:NO];
    state = (AFRequestState) AFRequestStateInProcess;
    [self broadcastToObservers:(AFRequestEvent) AFRequestEventStarted];
}

-(int)responseCode { return responseCode; }

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
        [NSException raise:NSInternalInconsistencyException format:@"Request had no Content-length in header! URL: %@", [URL absoluteString]];
    }
}

- (void)received:(NSData *)dataIn
{
    receivedBytes += [dataIn length];
    [self broadcastToObservers:(AFRequestEvent) AFRequestEventProgressUpdated];
}

- (void)didFinish
{
    state = (AFRequestState) AFRequestStateFulfilled;
    [self broadcastToObservers:(AFRequestEvent) AFRequestEventFinished];
}

- (void)didFail:(NSError *)error
{
    state = (AFRequestState) AFRequestStatePending;
    [self broadcastToObservers:(AFRequestEvent) AFRequestEventFailed];
}

- (void)cancel
{
    state = (AFRequestState) AFRequestStatePending;
    [connection cancel];
    [self broadcastToObservers:(AFRequestEvent) AFRequestEventCancel];
}

-(float)progress
{
    return expectedBytes > 0 ? (float) receivedBytes / (float) expectedBytes : 0;
}

- (void)addObserver:(NSObject <AFRequestObserver> *)newObserver
{
    [observers addObject:newObserver];
}

- (void)removeObserver:(NSObject <AFRequestObserver> *)oldObserver
{
    [observers removeObject:oldObserver];
}

- (void)broadcastToObservers:(AFRequestEvent)event
{
    const register NSSet *observerSnapshot = [[NSSet alloc] initWithSet:observers];
    @synchronized (observers)
    {
        for (NSObject *observer in observerSnapshot)
        {
            switch (event)
            {
                case (AFRequestEvent) AFRequestEventStarted:
                    if ([observer respondsToSelector:@selector(requestStarted:)]) [((NSObject <AFRequestObserver> *) observer) requestStarted:(NSObject <AFRequest> *) self];
                    break;

                case (AFRequestEvent) AFRequestEventProgressUpdated:
                    if ([observer respondsToSelector:@selector(requestProgressUpdated:forRequest:)]) [((NSObject <AFRequestObserver> *) observer) requestProgressUpdated:[self progress] forRequest:(NSObject <AFRequest> *) self];
                    break;

                case (AFRequestEvent) AFRequestEventFinished:
                    if ([observer respondsToSelector:@selector(requestComplete:)]) [((NSObject <AFRequestObserver> *) observer) requestComplete:(NSObject <AFRequest> *) self];
                    break;

                case (AFRequestEvent) AFRequestEventCancel:
                    if ([observer respondsToSelector:@selector(requestCancelled:)]) [((NSObject <AFRequestObserver> *) observer) requestCancelled:(NSObject <AFRequest> *) self];
                    break;

                case (AFRequestEvent) AFRequestEventFailed:
                    if ([observer respondsToSelector:@selector(requestFailed:)]) [((NSObject <AFRequestObserver> *) observer) requestFailed:(NSObject <AFRequest> *) self];
                    break;
                default:
                    break;
            }
        }
    }
    [observerSnapshot release];
}

- (BOOL)complete
{
    return receivedBytes >= expectedBytes;
}

- (NSString *)actionDescription { return nil; }

- (NSUInteger)          attempts        { return attempts;      }
- (BOOL)                requiresLogin   { return requiresLogin; }
- (NSURL *)             URL             { return URL;           }
- (NSURLConnection *)   connection      { return connection;    }
- (AFRequestState)      state           { return state;         }
- (NSUInteger)          receivedBytes   { return receivedBytes; }
- (int)                 expectedBytes   { return expectedBytes; }

- (void)setConnection:(NSURLConnection *)connectionIn
{
    if (connection != connectionIn)
    {
        [connectionIn retain];
        [connection release];
        connection = connectionIn;
    }
}

-(void)dealloc
{
    [numberFormatter release];
    [observers release];
    [connection release];
    [URL release];
    [super dealloc];
}

@end