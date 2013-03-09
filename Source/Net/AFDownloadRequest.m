#import <Foundation/Foundation.h>
#import "AFObservable.h"
#import "AFDownloadRequest.h"
#import "AFSession.h"
#import "AFHeaderRequest.h"
#import "AFRequest+Protected.h"
#import "AFFileUtils.h"
#import "AFLogger.h"
#import "AFParseHTTPContentRange.h"

// 512KB Buffer
#define DATA_BUFFER_LENGTH 524288
#define SIZE_CACHE_ERROR @""

@interface AFDownloadRequest ()

+(NSString *)createUniqueKeyFromURL:(NSURL *)URLIn localFilePath:(NSString *)localFilePathIn;
-(NSString *)uniqueKey;
-(void)updateReceivedBytesFromFile;

@end

@implementation AFDownloadRequest
{
    NSFileHandle        *fileHandle;
    NSString            *localFilePath;
    NSMutableDictionary *sizeCache;
    NSMutableData       *dataBuffer;
    AFHeaderRequest     *headerRequest;
}

static NSMutableDictionary *uniqueRequestPool = nil;

+ (AFDownloadRequest *)requestForURL:(NSURL*)               URLIn
                       localFilePath:(NSString*)            localFilePathIn
                           observers:(NSSet*)               observersIn
                       fileSizeCache:(NSMutableDictionary* )sizeCacheIn
               queueForHeaderRequest:(AFRequestQueue*)      queueIn
{
    NSAssert( URLIn!=nil,           @"URL must not be nil" );
    NSAssert( localFilePathIn!=nil, @"Local file path must not be nil" );

    if (!uniqueRequestPool) uniqueRequestPool = [[NSMutableDictionary alloc] init];

    NSString *uniqueKey = [AFDownloadRequest createUniqueKeyFromURL:URLIn localFilePath:localFilePathIn];

    AFDownloadRequest *request;
    if ((request = [uniqueRequestPool objectForKey:uniqueKey])) //If there is already a request for that key, just observe it
    {
        for (NSObject <AFRequestObserver> *l in observersIn) [request addObserver:l];
    }
    else //Otherwise, let's create a new request
    {
        request = [[AFDownloadRequest alloc] initWithURL:URLIn
                                              targetPath:localFilePathIn
                                               observers:observersIn
                                           fileSizeCache:sizeCacheIn
                               requestQueueForHeaderPoll:queueIn];

        [uniqueRequestPool setObject:request forKey:uniqueKey];
        [request release];
    }
    return request;
}

-(id)         initWithURL:(NSURL *)URLIn
               targetPath:(NSString *)targetPathIn
                observers:(NSSet *)observersIn
            fileSizeCache:(NSMutableDictionary *)sizeCacheIn
requestQueueForHeaderPoll:(AFRequestQueue *)queueIn
{
    NSAssert(URLIn,        NSInvalidArgumentException);
    NSAssert(targetPathIn, NSInvalidArgumentException);

    self = [self initWithURL:URLIn];

    if(self)
    {
        localFilePath = [targetPathIn retain];
        sizeCache     = [sizeCacheIn retain];
        dataBuffer    = [[NSMutableData alloc] initWithLength:DATA_BUFFER_LENGTH];

        if(observersIn) [self addObservers:[observersIn allObjects]];

        [self updateReceivedBytesFromFile];

        NSNumber *expectedSizeNumber = (NSNumber *) [sizeCache objectForKey:[URLIn absoluteString]];
        if (expectedSizeNumber)
        {
            //[self notifyObservers:AFRequestEventWillPollSize parameters:self, NULL];
            self.expectedBytes = [expectedSizeNumber intValue];
            //[self notifyObservers:AFRequestEventDidPollSize parameters:self, NULL];
        }

        if(queueIn)
        {
            [self notifyObservers:AFRequestEventWillPollSize parameters:self,NULL];

            headerRequest = [[AFHeaderRequest alloc] initWithURL:URLIn endpoint:self];
            [queueIn handleRequest:headerRequest];
            [headerRequest release];
        }
    }
    return self;
}

+(NSString*)createUniqueKeyFromURL:(NSURL*)URLIn localFilePath:(NSString*)localFilePathIn
{
    return [NSString stringWithFormat:@"%@¦%@", [URLIn absoluteString], localFilePathIn];
}

+(void)clearRequestPool { [uniqueRequestPool removeAllObjects]; }

+(BOOL)sizePolledForAllPooledRequests
{
    @synchronized (uniqueRequestPool)
    {for (NSString *curRequestKey in uniqueRequestPool)if (((AFDownloadRequest *) [uniqueRequestPool objectForKey:curRequestKey]).expectedBytes == -1) return NO;}
    return YES;
}

-(NSString*)uniqueKey
{
    return [AFDownloadRequest createUniqueKeyFromURL:self.URL localFilePath:self.localFilePath];
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn
{
    AFLogPosition();

    [super willSendURLRequest:requestIn];

    [self updateReceivedBytesFromFile];

    if (self.receivedBytes > 0)
    {
        NSString *contentRange = [NSString stringWithFormat:@"bytes=%i-", self.receivedBytes];
        [requestIn setValue:contentRange forHTTPHeaderField:@"Range"];

        NSLog(@"Requesting %@ from %@",contentRange,[URL absoluteString]);
    }
    return requestIn;
}

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCodeIn
{
    AFLogPosition();

    [super willReceiveWithHeaders:headers responseCode:responseCodeIn];

    if( [self isSuccessHTTPResponse] )
    {
        NSLog(@"Will begin writing to file '%@'", localFilePath);

        NSURL* fileURL = [NSURL fileURLWithPath:localFilePath];

        NSError* error = nil;

        if (![self existsInLocalStorage])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];

            NSLog(@"Creating file: %@", localFilePath);
            [AFFileUtils createAncestorDirectoriesForPath:fileURL error:&error];
            [fileManager createFileAtPath:localFilePath contents:nil attributes:nil];
            NSAssert(!error, [error localizedDescription]);
        }

        fileHandle = [[NSFileHandle fileHandleForWritingToURL:fileURL error:&error] retain];

        NSAssert(fileHandle, @"Couldn't open a file handle to receive '%@'", [URL absoluteString]);

        switch(responseCodeIn)
        {
            case 206:
            {
                AFRangeInfo* rangeInfo = CreateAFRangeInfoFromHTTPHeaders(headers);
                NSRange      range     = rangeInfo->contentRange;
                NSUInteger   total     = rangeInfo->contentTotal;
                free(rangeInfo);

                if(self.expectedBytes != rangeInfo->contentTotal)
                {
                    @throw [NSException exceptionWithName:NSRangeException reason:@"" userInfo:NULL];
                }

                [fileHandle seekToFileOffset:range.location];
            }
            break;

            default:
            {
                [fileHandle truncateFileAtOffset:0];
                self.receivedBytes = 0;
            }
            break;
        }
    }
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

    [fileHandle writeData:dataIn];

    /*
    if ([dataIn length] > DATA_BUFFER_LENGTH) //It's a large chunk of data, worth writing immediately
    {
        [fileHandle writeData:dataBuffer];
    }
    else //It's not much data, let's just buffer it in RAM
    {
        const int bufferSpaceRemaining = DATA_BUFFER_LENGTH- dataBufferPosition;

        if ([dataIn length] > bufferSpaceRemaining) //There's not enough buffer space
        {
            [dataBuffer replaceBytesInRange:NSMakeRange(dataBufferPosition, (NSUInteger) bufferSpaceRemaining) withBytes:[dataIn bytes] length:(NSUInteger) bufferSpaceRemaining];
            [fileHandle writeData:dataBuffer];
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
    */
}

- (NSString *)actionDescription { return @"Downloading file"; }

- (void)didFinish;
{
    /*
    if (dataBufferPosition > 0)
    {
        NSData *finalData = [[NSData alloc] initWithBytes:[dataBuffer bytes] length:dataBufferPosition];
        [fileHandle writeData:finalData];
        [finalData release];
    }
    */

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
    if (fileHandle)
    {
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
        [fileHandle release];
        fileHandle = nil;
    }
}

- (void)setExpectedBytes:(int)expectedBytesIn
{
    [super setExpectedBytes:expectedBytesIn];

    NSString
            *expectedBytesString = [[NSNumber numberWithInt:expectedBytesIn] stringValue],
            *uniqueKey           = self.uniqueKey;

    [sizeCache setObject:expectedBytesString forKey:uniqueKey];
}


- (void)request:(AFRequest*)request returnedWithData:(id)header
{
    AFLogPosition();
    NSAssert(request == headerRequest, @"AFDownloadRequest received response from an unexpected request: %@", request);

    AFRangeInfo* rangeInfo = CreateAFRangeInfoFromHTTPHeaders(header);
    self.expectedBytes = rangeInfo->contentTotal;
    free(rangeInfo);

    [self notifyObservers:AFRequestEventDidPollSize parameters:self, NULL];
}

- (void)requestFailed:(AFRequest *)request withError:(NSError*)errorIn
{
    AFLogPosition();
    NSAssert(request == headerRequest, @"AFDownloadRequest received response from an unexpected request: %@", request);

    self.error = errorIn;

    NSString* uniqueKey = self.uniqueKey;
    [sizeCache setObject:SIZE_CACHE_ERROR forKey:uniqueKey];
    [self setState:AFRequestStateFailed];
}


- (void)deleteLocalFile
{
    if( self.state == AFRequestStateInProcess )[self cancel];
    if( [self existsInLocalStorage] )[[NSFileManager defaultManager] removeItemAtPath:localFilePath error:nil];
    self.receivedBytes = 0;
    [self notifyObservers:AFRequestEventCancel parameters:self,NULL];
}

- (BOOL)existsInLocalStorage
{
    return [[NSFileManager defaultManager] fileExistsAtPath:localFilePath];
}

- (void)updateReceivedBytesFromFile
{
    if( [self existsInLocalStorage] )
    {
        NSDictionary *fileAttributes;
        NSError      *error = nil;
        if( (fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:localFilePath error:&error] ) && !error )
        {
            int fileSizeBytes = [[fileAttributes objectForKey:NSFileSize] intValue];
            self.receivedBytes = fileSizeBytes;
        }
        else [NSException raise:NSInternalInconsistencyException format:@"File exists at '%@' but couldn't read its attributes. Error: %@", localFilePath, [error localizedDescription]];
    }
    else
    {
        self.receivedBytes = 0;
    }
}

- (void)dealloc
{
    [sizeCache          release];
    [numberFormatter    release];
    [localFilePath      release];
    [dataBuffer         release];
    [fileHandle         release];
    [super dealloc];
}

@synthesize localFilePath;

@end
