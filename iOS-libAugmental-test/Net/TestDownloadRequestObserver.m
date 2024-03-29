//
// Created by augmental on 25/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TestDownloadRequestObserver.h"
#import "AFRequest.h"
#import "NSObject+SenTest.h"

static NSString
    *expectedString     = @"Download test, 1. 2.. 3...",
    *wrongRequestReason = @"Observer was shown an unexpected request",
    *wrongDataReason    = @"The received data was wrong";

@implementation TestDownloadRequestObserver
{
    AFRequest*  request;
    id          callbackObject;
    SEL         callbackSelector;
}

- (id)initWithRequest:(AFRequest *)requestIn
       callbackObject:(id)callbackObjectIn
     callbackSelector:(SEL)selectorIn
{
    self = [self init];
    if(self)
    {
        request          = [requestIn retain];
        callbackObject   = [callbackObjectIn retain];
        callbackSelector = selectorIn;
    }
    return self;
}


-(void)requestStarted:             (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );
}

-(void)requestProgressUpdated:     (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );

    float progress = [requestIn progress];
    STAssertTrue( progress >= 0.0 && progress <= 1.0, @"Progress outside range 0 <= x <= 1" );
}

-(void)requestComplete:            (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );

    [callbackObject performSelector:callbackSelector];
}

-(void)requestCancelled:           (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );
}

-(void)requestFailed:              (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );
}

-(void)handleRequest:              (AFRequest*)requestIn queuedAt:(NSNumber *)positionIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );
}

-(void)handleRequestReset:         (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );
}

-(void)handleRequestWillPollSize:  (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );
}

-(void)handleRequestDidPollSize:   (AFRequest*)requestIn
{
    STAssertEqualObjects( requestIn, request, wrongRequestReason );

    STAssertEquals( requestIn.expectedBytes, 26, wrongDataReason );
}

- (void)dealloc
{
    [request release];
    [super dealloc];
}

@end