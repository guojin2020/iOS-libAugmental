#import "AFDownloadRequest.h"
#import "AFQueueableRequestObserver.h"
#import "AFSession.h"
#import "AFHeaderRequest.h"
#import "AFPerformSelectorOperation.h"

// 512KB Buffer
#define DATA_BUFFER_LENGTH 524288

@implementation AFDownloadRequest

static NSMutableDictionary *uniqueRequestPool = nil;

+ (AFDownloadRequest *)requestForURL:(NSURL *)URLIn
                          targetPath:(NSString *)targetPathIn
                           observers:(NSSet *)observersIn
                       fileSizeCache:(NSDictionary *)sizeCacheIn
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
        request = [[AFDownloadRequest alloc] initWithURL:URLIn targetPath:targetPathIn observers:observersIn fileSizeCache:sizeCacheIn];
        [uniqueRequestPool setObject:request forKey:uniqueKey];
        [request release];
    }
    return request;
}

+ (void)clearRequestPool
{[uniqueRequestPool removeAllObjects];}

+ (BOOL)sizePolledForAllPooledRequests
{
    @synchronized (uniqueRequestPool)
    {for (NSString *curRequestKey in uniqueRequestPool)if (((AFDownloadRequest *) [uniqueRequestPool objectForKey:curRequestKey]).expectedBytes == -1) return NO;}
    return YES;
}

- (id)initWithURL:(NSURL *)URLIn targetPath:(NSString *)targetPathIn observers:(NSSet *)observersIn fileSizeCache:(NSMutableDictionary *)sizeCacheIn
{
    NSAssert(URLIn && targetPathIn && sizeCacheIn, @"Bad parameters when initing %@\nURLIn: %@\ntargetPathIn: %@\nsizeCacheIn: %@\n", [self class], URLIn, targetPathIn, sizeCacheIn);

    if ((self = [super initWithURL:URLIn]))
    {
        sizeCache  = [sizeCacheIn retain];
        targetPath = [targetPathIn retain];
        [observers addObjectsFromArray:[observersIn allObjects]];
        dataBuffer = [[NSMutableData alloc] initWithLength:DATA_BUFFER_LENGTH];

        [self updateReceivedBytesFromFile];

        NSNumber *expectedSizeNumber = (NSNumber *) [sizeCache objectForKey:[URLIn absoluteString]];
        if (expectedSizeNumber)
        {
            expectedBytes = [expectedSizeNumber intValue];
            [self broadcastToObservers:(requestEvent) sizePolled];
        }

        if (![AFSession sharedSession].offline)
        {
            pollSizeRequest = [[AFHeaderRequest alloc] initWithURL:URL endpoint:self];
            [[AFSession sharedSession] handleRequest:pollSizeRequest];
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

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCode
{
    NSLog(@"Will begin writing to file '%@'",targetPath);

    state = (requestState) inProcess;
    [self broadcastToObservers:(requestEvent) started];

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

    NSAssert(myHandle!=nil, @"Couldn't open a file handle to receive '%@'", [URL absoluteString]);

    if (responseCode == 206)[myHandle seekToEndOfFile];
    else if (responseCode == 200)
    {
        [myHandle truncateFileAtOffset:0];
        receivedBytes = 0;
    }
    else
    {
        NSLog(@"Unexcepted HTTP response code (%i) to from request to '%@'", responseCode, [URL absoluteString]);
        //[NSException raise:NSInternalInconsistencyException format:@"Unexcepted HTTP response code (%i) to from request to '%@'", responseCode, [URL absoluteString]];
    }
}

- (void)received:(NSData *)dataIn
{
    [super received:dataIn];

    if ([dataIn length] > DATA_BUFFER_LENGTH) //It's a large chunk of data, worth writing immediately
    {
        [myHandle writeData:dataBuffer];
        //[self performSelectorOnCommonBackgroundThread:@selector(writeDataInternal:) withObject:dataIn];
    }
    else //It's not much data, let's just buffer it in RAM
    {
        const int bufferSpaceRemaining = DATA_BUFFER_LENGTH- dataBufferPosition;

        if ([dataIn length] > bufferSpaceRemaining) //Theres not enough buffer space
        {
            [dataBuffer replaceBytesInRange:NSMakeRange(dataBufferPosition, bufferSpaceRemaining) withBytes:[dataIn bytes] length:bufferSpaceRemaining];
            [myHandle writeData:dataBuffer];
            const int leftOverBytes = [dataIn length] - bufferSpaceRemaining;
            [dataBuffer replaceBytesInRange:NSMakeRange(0, leftOverBytes) withBytes:[[dataIn subdataWithRange:NSMakeRange(bufferSpaceRemaining, leftOverBytes)] bytes]];
            dataBufferPosition = leftOverBytes;
        }
        else //There is enough buffer space
        {
            [dataBuffer replaceBytesInRange:NSMakeRange(dataBufferPosition, [dataIn length]) withBytes:[dataIn bytes]];
            dataBufferPosition += [dataIn length];
        }
    }
}

- (NSString *)actionDescription
{return @"Downloading file";}

/*
- (void)writeDataInternal:(NSData *)data
{
    [myHandle writeData:data];
}
*/

- (void)didFinish;
{
    [super didFinish];
    if (dataBufferPosition > 0)
    {
        NSData *finalData = [[NSData alloc] initWithBytes:[dataBuffer bytes] length:dataBufferPosition];
        [myHandle writeData:finalData];
        [finalData release];
    }
    [self closeHandleSafely];
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

- (void)requestQueuedAtPosition:(int)queuePositionIn;
{
    queuePosition = queuePositionIn;
    [self broadcastToObservers:(requestEvent) queued];
}

- (void)broadcastToObservers:(requestEvent)event
{
    NSSet *observerSnapshot = [[NSSet alloc] initWithSet:observers];
    switch (event)
    {
        case (requestEvent) queued:
            for (NSObject *observer in observerSnapshot)if ([observer conformsToProtocol:@protocol(AFQueueableRequestObserver)])[(NSObject <AFQueueableRequestObserver> *) observer requestQueued:(NSObject <AFQueueableRequest> *) self AtPosition:queuePosition];
            break;
        case (requestEvent) sizePolled:
            for (NSObject *observer in observerSnapshot)if ([observer respondsToSelector:@selector(requestSizePolled:forRequest:)])[(NSObject <AFRequestObserver> *) observer requestSizePolled:(int) expectedBytes forRequest:self];
            break;
        case (requestEvent) reset:
            for (NSObject *observer in observerSnapshot)if ([observer respondsToSelector:@selector(requestReset:)]) [(NSObject <AFRequestObserver> *) observer requestReset:(NSObject <AFRequest> *) self];
            break;
        default:
            [super broadcastToObservers:event];
            break;
    }
    [observerSnapshot release];
}

- (void)request:(NSObject <AFRequest> *)request returnedWithData:(id)header
{
    NSAssert(request == pollSizeRequest, @"AFDownloadRequest received response from an unexpected request: %@", request);
    [self setExpectedBytesFromHeader:header isCritical:YES];
    [self broadcastToObservers:(requestEvent) sizePolled];
}

- (void)deleteLocalCopy
{
    if (state == (requestState) inProcess)[self cancel];
    if ([self existsInLocalStorage])[[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
    receivedBytes = 0;
    [self broadcastToObservers:(requestEvent) reset];
}

- (BOOL)existsInLocalStorage
{return [[NSFileManager defaultManager] fileExistsAtPath:targetPath];}

- (BOOL)complete
{return receivedBytes >= expectedBytes;}

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
    [uniqueRequestPool release];
    [observers release];
    [targetPath release];
    [dataBuffer release];
    [myHandle release];
    [uniqueKey release];
    [super dealloc];
}

-(NSString *)targetPath
{
    return targetPath;
}

@synthesize uniqueKey;
@dynamic requiresLogin, attempts;

//@dynamic receivedBytes, connection, URL, state;

@end
