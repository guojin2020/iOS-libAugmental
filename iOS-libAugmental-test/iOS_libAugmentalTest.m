//
//  iOS_libAugmentalTest.m
//  iOS-libAugmental-test
//
//  Created by Chris Hatton on 14/10/2012.
//
//

#import "iOS_libAugmentalTest.h"
#import "AFDownloadRequest.h"
#import "AFRequestQueue.h"
#import "AFSession.h"
#import "TestDownloadRequestObserver.h"
#import "AFUtil.h"

@implementation iOS_libAugmentalTest
{
    NSCondition *requestWaitLock;
}

- (void)setUp
{
    [super setUp];

    requestWaitLock = [[[NSCondition alloc] init] retain];
    requestWaitLock.name = @"Wait for Network requests";
}

- (void)tearDown
{
    [requestWaitLock release];
    [requestWaitLock release];
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
    NSURL*      testURL     = [[NSURL alloc] initWithString:urlPath];
    NSString*   basePath    = [AFUtil applicationDocumentsDirectory];
    NSString*   targetPath  = [NSString stringWithFormat:@"%@/%@", basePath, fileName, nil];

    AFSession* session = [[AFSession alloc] init];

    AFDownloadRequest* request = [AFDownloadRequest alloc];

    id<AFRequestObserver> observer = [[TestDownloadRequestObserver alloc] initWithRequest:request
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
    STAssertEqualObjects( [request targetPath], targetPath, @"Target path reported incorrectly" );

    [testURL release];

    STAssertFalse( [request complete], @"Request" );

    //[session handleRequest:request];
    [session queueRequestAtBack:request];

    [requestWaitLock lock];
    while(![request complete]) [requestWaitLock wait];
    [requestWaitLock unlock];

    [request release];

    [session release];
}

-(void)completeDownloadRequestTest
{
    [requestWaitLock lock];
    [requestWaitLock signal];
    [requestWaitLock unlock];
}

@end
