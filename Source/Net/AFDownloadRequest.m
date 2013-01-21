#import "AFObservable.h"
#import "AFDownloadRequest.h"
#import "AFSession.h"
#import "AFHeaderRequest.h"

// 512KB Buffer
#define DATA_BUFFER_LENGTH 524288

@interface AFDownloadRequest ()

- (void)updateReceivedBytesFromFile;

@end

@implementation AFDownloadRequest
{
    NSFileHandle        *myHandle;
    NSString            *targetPath;
    NSMutableDictionary *sizeCache;
    NSUInteger          queuePosition;
    NSString            *uniqueKey;
    NSMutableData       *dataBuffer;
    NSUInteger          dataBufferPosition;
    AFHeaderRequest     *pollSizeRequest;
}

static NSMutableDictionary *uniqueRequestPool = nil;

+ (AFDownloadRequest *)requestForURL:(NSURL *)URLIn
                          targetPath:(NSString *)targetPathIn
                           observers:(NSSet *)observersIn
                       fileSizeCache:(NSMutableDictionary *)sizeCacheIn
           requestQueueForHeaderPoll:(AFRequestQueue *)queueIn
{
    if (!uniqueRequestPool) uniqueRequestPool = [[NSMutableDictionary alloc] init];

    NSString *uniqueKey = [NSString stringWithFormat:@"%@%@", [URLIn absoluteString], targetPathIn];

    AFDownloadRequest *request;
    if ((request = [uniqueRequestPool objectForKey:uniqueKey])) //If there is already a request for that key, just observe it
    {
        for (NSObject <AFRequestObserver> *l in observersIn) [request addObserver:l];
    }
    else //Otherwise, let's create a new request
    {
        request = [[AFDownloadRequest alloc] initWithURL:URLIn
                                              targetPath:targetPathIn
                                               observers:observersIn
                                           fileSizeCache:sizeCacheIn
                               requestQueueForHeaderPoll:queueIn];

        [uniqueRequestPool setObject:request forKey:uniqueKey];
        [request release];
    }
    return request;
}

+(void)clearRequestPool { [uniqueRequestPool removeAllObjects]; }

+(BOOL)sizePolledForAllPooledRequests
{
    @synchronized (uniqueRequestPool)
    {for (NSString *curRequestKey in uniqueRequestPool)if (((AFDownloadRequest *) [uniqueRequestPool objectForKey:curRequestKey]).expectedBytes == -1) return NO;}
    return YES;
}

- (id)        initWithURL:(NSURL *)URLIn
               targetPath:(NSString *)targetPathIn
                observers:(NSSet *)observersIn
            fileSizeCache:(NSMutableDictionary *)sizeCacheIn
requestQueueForHeaderPoll:(AFRequestQueue *)queueIn
{
    NSAssert(URLIn && targetPathIn && sizeCacheIn, @"Bad parameters when initing %@\nURLIn: %@\ntargetPathIn: %@\nsizeCacheIn: %@\n", [self class], URLIn, targetPathIn, sizeCacheIn);

    if ((self = [super initWithURL:URLIn]))
    {
        sizeCache  = [sizeCacheIn retain];
        targetPath = [targetPathIn retain];
        [self addObservers:[observersIn allObjects]];
        dataBuffer = [[NSMutableData alloc] initWithLength:DATA_BUFFER_LENGTH];

        [self updateReceivedBytesFromFile];

        NSNumber *expectedSizeNumber = (NSNumber *) [sizeCache objectForKey:[URLIn absoluteString]];
        if (expectedSizeNumber)
        {
            expectedBytes = [expectedSizeNumber intValue];
            [self notifyObservers:AFRequestEventSizePolled parameters:self,NULL];
        }

        if(queueIn)
        {
            pollSizeRequest = [[AFHeaderRequest alloc] initWithURL:URLIn endpoint:self];
            [queueIn handleRequest:pollSizeRequest];
            [pollSizeRequest release];
        }
    }
    return self;
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn
{
    [super willSendURLRequest:requestIn];

    [self updateReceivedBytesFromFile];
    if (receivedBytes > 0)
    {
        NSString *contentRange = [NSString stringWithFormat:@"bytes=%i-", receivedBytes];
        [requestIn setValue:contentRange forHTTPHeaderField:@"Range"];

        //NSLog(@"Requesting %@ from %@",contentRange,[URL absoluteString]);
    }
    return requestIn;
}

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCodeIn
{
    [super willReceiveWithHeaders:headers responseCode:responseCodeIn];

    if( [self isSuccessHTTPResponse] )
    {
        NSLog(@"Will begin writing to file '%@'",targetPath);

        //state = (AFRequestState) AFRequestStateInProcess;
        //[self broadcastToObservers:(AFRequestEvent) AFRequestEventStarted];

        //[self notifyObservers:AFRequestEventStarted parameters:self];

        NSURL* fileURL = [NSURL fileURLWithPath:targetPath];

        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSError* error = nil;

        BOOL isDirectory = NO;
        NSString* directoryPath = [[fileURL URLByDeletingLastPathComponent] path];
        if(![fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory])
        {
            NSLog(@"Creating directory: %@", directoryPath);
            [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        }

        NSAssert(!error, [error localizedDescription]);

        if (![self existsInLocalStorage])
        {
            NSLog(@"Creating file: %@", targetPath);
            [fileManager createFileAtPath:targetPath contents:nil attributes:nil];
        }

        myHandle = [[NSFileHandle fileHandleForWritingAtPath:targetPath] retain];

        [NSFileHandle fileHandleForWritingToURL:fileURL error:&error];

        NSAssert(myHandle, @"Couldn't open a file handle to receive '%@'", [URL absoluteString]);


        bool appendFile;

        switch(responseCodeIn)
        {
            case 206:
                appendFile = true;

            default:
                appendFile = false;
        }

        if(appendFile)
        {
            [myHandle seekToEndOfFile];
        }
        else
        {
            [myHandle truncateFileAtOffset:0];
            receivedBytes = 0;
        }
    }
    /*
    else
    {
        bool shouldRetry;

        switch (responseCodeIn)
        {
            case 416:
                shouldRetry = true;

            default:
                shouldRetry = false;
        }
    }
    */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *url;

    switch (buttonIndex)
    {
        case 1:
            url = [NSString stringWithFormat: @"mailto:chris@pocket-innovation.com?&subject=Pocket%%20Trainer%%20support%%20request&body=Error%%20code%%20%i",responseCode];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
            break;

        default: @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unexpected button index" userInfo:NULL];
    }
}


- (void)received:(NSData *)dataIn
{
    [super received:dataIn];

    if ([dataIn length] > DATA_BUFFER_LENGTH) //It's a large chunk of data, worth writing immediately
    {
        [myHandle writeData:dataBuffer];
    }
    else //It's not much data, let's just buffer it in RAM
    {
        const int bufferSpaceRemaining = DATA_BUFFER_LENGTH- dataBufferPosition;

        if ([dataIn length] > bufferSpaceRemaining) //There's not enough buffer space
        {
            [dataBuffer replaceBytesInRange:NSMakeRange(dataBufferPosition, (NSUInteger) bufferSpaceRemaining) withBytes:[dataIn bytes] length:(NSUInteger) bufferSpaceRemaining];
            [myHandle writeData:dataBuffer];
            NSUInteger leftOverBytes = [dataIn length] - bufferSpaceRemaining;
            [dataBuffer replaceBytesInRange:NSMakeRange(0, leftOverBytes) withBytes:[[dataIn subdataWithRange:NSMakeRange((NSUInteger) bufferSpaceRemaining, leftOverBytes)] bytes]];
            dataBufferPosition = leftOverBytes;
        }
        else //There is enough buffer space
        {
            [dataBuffer replaceBytesInRange:NSMakeRange(dataBufferPosition, [dataIn length]) withBytes:[dataIn bytes]];
            dataBufferPosition += [dataIn length];
        }
    }
}

- (NSString *)actionDescription { return @"Downloading file"; }

- (void)didFinish;
{
    if (dataBufferPosition > 0)
    {
        NSData *finalData = [[NSData alloc] initWithBytes:[dataBuffer bytes] length:dataBufferPosition];
        [myHandle writeData:finalData];
        [finalData release];
    }
    [self closeHandleSafely];

    [super didFinish];
}

- (void)didFail:(NSError *)error
{
    [super didFail:error];
    [self closeHandleSafely];
}

- (void)cancel
{
    [super cancel];
    [self closeHandleSafely];
}

- (void)closeHandleSafely
{
    if (myHandle)
    {
        [myHandle synchronizeFile];
        [myHandle closeFile];
        [myHandle release];
        myHandle = nil;
    }
}

- (void)requestWasQueuedAtPosition:(NSUInteger)queuePositionIn;
{
    queuePosition = (NSUInteger) queuePositionIn;
    [self notifyObservers:AFRequestEventQueued parameters:self,NULL];
}

- (void)requestWasUnqueued
{
    state = AFRequestStateIdle;
}

- (void)request:(AFRequest*)request returnedWithData:(id)header
{
    NSAssert(request == pollSizeRequest, @"AFDownloadRequest received response from an unexpected request: %@", request);
    [self setExpectedBytesFromHeader:header isCritical:YES];
    [self notifyObservers:AFRequestEventSizePolled parameters:self,NULL];
}

- (void)deleteLocalCopy
{
    if (state == (AFRequestState) AFRequestStateInProcess)[self cancel];
    if ([self existsInLocalStorage])[[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
    receivedBytes = 0;
    [self notifyObservers:AFRequestEventReset parameters:self,NULL];
}

- (BOOL)existsInLocalStorage
{
    return [[NSFileManager defaultManager] fileExistsAtPath:targetPath];
}

- (void)updateReceivedBytesFromFile
{
    if ([self existsInLocalStorage])
    {
        NSDictionary *fileAttributes;
        NSError      *error = nil;
        if ((fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:targetPath error:&error]) && !error)
        {
            receivedBytes = [[fileAttributes objectForKey:NSFileSize] intValue];
        }
        else [NSException raise:NSInternalInconsistencyException format:@"File exists at '%@' but couldn't read its attributes. Error: %@", targetPath, [error localizedDescription]];
    }
    else
    {
        receivedBytes = 0;
    }
}

- (void)dealloc
{
    [sizeCache release];
    [numberFormatter release];
    [targetPath release];
    [dataBuffer release];
    [myHandle release];
    [uniqueKey release];
    [super dealloc];
}

@synthesize uniqueKey;
@synthesize targetPath;

@end
