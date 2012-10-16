#import "AFBaseRequest.h"
//#import "AFAppDelegate.h"

@implementation AFBaseRequest

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
        state = (requestState) pending;
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

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCode
{
    [self setExpectedBytesFromHeader:headers isCritical:NO];
    state = (requestState) inProcess;
    [self broadcastToObservers:(requestEvent) started];
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
        [NSException raise:NSInternalInconsistencyException format:@"Request had no Content-length in header! URL: %@", [URL absoluteString]];
    }
}

- (void)received:(NSData *)dataIn
{
    receivedBytes += [dataIn length];
    [self broadcastToObservers:(requestEvent) progressUpdated];
}

- (void)didFinish
{
    state = (requestState) fulfilled;
    [self broadcastToObservers:(requestEvent) finished];
}

- (void)didFail:(NSError *)error
{
    state = (requestState) pending;
    [self broadcastToObservers:(requestEvent) failed];
}

- (void)cancel
{
    state = (requestState) pending;
    [connection cancel];
    [self broadcastToObservers:(requestEvent) cancel];
}

- (float)progress
{
    return expectedBytes > 0 ? (float) receivedBytes / (float) expectedBytes : 0;
}

- (void)addObserver:(NSObject <AFRequestObserver> *)newObserver
{[observers addObject:newObserver];}

- (void)removeObserver:(NSObject <AFRequestObserver> *)oldObserver
{[observers removeObject:oldObserver];}

- (BOOL)requiresLogin
{return requiresLogin;}

- (void)broadcastToObservers:(requestEvent)event
{
    const register NSSet *observerSnapshot = [[NSSet alloc] initWithSet:observers];
    @synchronized (observers)
    {
        for (NSObject *observer in observerSnapshot)
        {
            switch (event)
            {
                case (requestEvent) started:
                    if ([observer respondsToSelector:@selector(requestStarted:)]) [((NSObject <AFRequestObserver> *) observer) requestStarted:(NSObject <AFRequest> *) self];
                    break;

                case (requestEvent) progressUpdated:
                    if ([observer respondsToSelector:@selector(requestProgressUpdated:forRequest:)]) [((NSObject <AFRequestObserver> *) observer) requestProgressUpdated:[self progress] forRequest:(NSObject <AFRequest> *) self];
                    break;

                case (requestEvent) finished:
                    if ([observer respondsToSelector:@selector(requestComplete:)]) [((NSObject <AFRequestObserver> *) observer) requestComplete:(NSObject <AFRequest> *) self];
                    break;

                case (requestEvent) cancel:
                    if ([observer respondsToSelector:@selector(requestCancelled:)]) [((NSObject <AFRequestObserver> *) observer) requestCancelled:(NSObject <AFRequest> *) self];
                    break;

                case (requestEvent) failed:
                    if ([observer respondsToSelector:@selector(requestFailed:)]) [((NSObject <AFRequestObserver> *) observer) requestFailed:(NSObject <AFRequest> *) self];
                    break;
                default:
                    break;
            }
        }
    }
    [observerSnapshot release];
}

-(int)attempts {return attempts;}

-(void)dealloc
{
    [numberFormatter release];
    [observers release];
    [connection release];
    [URL release];
    [super dealloc];
}

@synthesize URL, connection, state, receivedBytes, expectedBytes;

@end
