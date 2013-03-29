
#import "iOS_libAugmentalTest.h"
#import "AFDownloadRequest.h"
#import "AFRequestQueue.h"
#import "AFSession.h"
#import "TestDownloadRequestObserver.h"
#import "AFFileUtils.h"

@implementation iOS_libAugmentalTest
{
    //NSCondition *requestWaitLock;
    bool isComplete;
}

- (void)setUp
{
    [super setUp];

    //requestWaitLock = [[[NSCondition alloc] init] retain];
    //requestWaitLock.name = @"Wait for Network requests";

    isComplete = NO;
}

- (void)tearDown
{
    //[requestWaitLock release];
    //[requestWaitLock release];
    [super tearDown];
}

-(void)testRequestQueue
{
    AFRequestQueue *queue = [[AFRequestQueue alloc] init];
    [queue release];
}

-(void)testDownloadRequest
{
    // A small 26 byte text file containing the string "Download test, 1. 2.. 3..."
    NSString*   fileName    = @"downloadTest.txt";
    NSString*   urlPath     = [NSString stringWithFormat:@"http://chrishatton.homeip.net/downloads/%@", fileName, nil];
    
    NSLog(@"Testing Download Request for URL: %@", urlPath);
    
    NSURL*      testURL     = [[NSURL alloc] initWithString:urlPath];
    NSString*   basePath    = [AFFileUtils documentsDirectory];
    NSString*   targetPath  = [NSString stringWithFormat:@"%@/%@", basePath, fileName, nil];

    AFSession* session = [[AFSession alloc] init];

    AFDownloadRequest* request = [AFDownloadRequest alloc];

    NSObject<AFRequestObserver> *observer = [[TestDownloadRequestObserver alloc] initWithRequest:request
                                                                                  callbackObject:self
                                                                         callbackSelector:@selector(completeDownloadRequestTest)];
    NSSet* observers = [[NSSet alloc] initWithObjects:observer, nil];
    [observer release];

    [request initWithURL:testURL
              targetPath:targetPath
               observers:observers
           fileSizeCache:NULL
           requestQueueForHeaderPoll:session];

    [observers release];

    STAssertEquals( [request receivedBytes], 0, @"AFDownloadRequest shouldn't have received any bytes yet." );
    STAssertEqualObjects( [request localFilePath], targetPath, @"Target path reported incorrectly" );

    [testURL release];

    STAssertFalse( [request complete], @"Request" );

    [session handleRequest:request];
    [session queueRequestAtBack:request];

    //[requestWaitLock lock];
    
    do
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.00]];
    }
    while (!isComplete);
    
    //while(![request complete]) [requestWaitLock wait];
    //[requestWaitLock unlock];

    [request release];

    [session release];
}

-(void)completeDownloadRequestTest
{
    isComplete = YES;
    
    //[requestWaitLock lock];
    //[requestWaitLock signal];
    //[requestWaitLock unlock];
}

@end
