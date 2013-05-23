//
// Created by Chris Hatton on 03/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFSKProductFetcher.h"

#import "AFSKProductRequest.h"
#import "AFPSKProductConsumer.h"
#import "AFSKProductFetchResponse.h"
#import "AFSKProductFetchResponseSuccess.h"
#import "AFSKProductFetchResponseFailed.h"
#import "AFLog.h"

@interface AFSKProductFetcher ()

- (void)sendRequests;

@end

@implementation AFSKProductFetcher {}

static AFSKProductFetcher *defaultCache;

+(AFSKProductFetcher *)sharedInstance
{
    return defaultCache ?: (defaultCache = [[AFSKProductFetcher alloc] init]);
}

-(id)init
{
    self = [super init];
    if (self)
    {
        bufferedRequests    = [[NSMutableSet alloc] init];
        activeRequests      = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)lock
{
    ++bufferLockCount;
}

- (void)unlock
{
    if(bufferLockCount>0)
    {
        --bufferLockCount;
        if(bufferLockCount==0 && [bufferedRequests count]>0)
        {
            [self sendRequests];
        }
    }
}

-(AFSKProductRequest*)requestProductForConsumer:(NSObject<AFPSKProductConsumer>*)consumer
{
    AFSKProductRequest* request;

    if (consumer.storeKitProductId)
    {
        request = [[AFSKProductRequest alloc] initWithConsumer:consumer];
        [bufferedRequests addObject:request];
        [request release];

        if (bufferLockCount==0) [self sendRequests];
    }
    else
    {
        request = NULL;
    }

    return request;
}

-(void)sendRequests
{
    NSAssert([activeRequests count]==0,@"There should never be any active requests when sendRequests is invoked.");

    if([bufferedRequests count]==0) return;

    NSMutableSet *swapSet = activeRequests;
    activeRequests   = bufferedRequests;
    bufferedRequests = swapSet;

    NSMutableSet *productIds = [[NSMutableSet alloc] init];
    for(AFSKProductRequest *activeRequest in activeRequests)
    {
        [productIds addObject:activeRequest.productConsumer.storeKitProductId];
    }

    storeKitRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    [productIds release];

    storeKitRequest.delegate = self;
    [storeKitRequest start];
}

// SKProductsRequestDelegate implementation

- (void)productsRequest:(SKProductsRequest *)storeKitRequestIn didReceiveResponse:(SKProductsResponse *)storeKitResponse
{
    NSAssert ( storeKitRequest==storeKitRequestIn, @"" );

    BOOL found;
    AFSKProductRequest *request;
    AFSKProductFetchResponse *response;

    for(SKProduct* product in storeKitResponse.products)
    {
        found = NO;
        for(request in [activeRequests copy])
        {
            if([request.productConsumer.storeKitProductId isEqualToString:product.productIdentifier])
            {
                found = YES;
	            [activeRequests removeObject:request];
                response = [[AFSKProductFetchResponseSuccess alloc] initWithProduct:product];
	            [request.productConsumer didReceiveResponse:response toProductRequest:request];
                [response release];
            }
        }
    }

    for(request in activeRequests)
    {
        response = [[AFSKProductFetchResponseFailed alloc] initWithReason:@"currently unavailable"];
	    [request.productConsumer didReceiveResponse:response toProductRequest:request];
        [response release];
    }

    [activeRequests removeAllObjects];

    [self unlock];

    [storeKitRequest release];
}

- (void)requestDidFinish:(SKRequest *)request
{
    AFLogPosition();
}

- (void)request:(SKRequest *)storeKitRequestIn didFailWithError:(NSError *)error
{
    NSAssert ( storeKitRequest==storeKitRequestIn, @"" );

	AFSKProductRequest *request;
	AFSKProductFetchResponse *response;

	for(request in activeRequests)
	{
		response = [[AFSKProductFetchResponseFailed alloc] initWithReason:@"Could not contact iTunes"];
		[request.productConsumer didReceiveResponse:response toProductRequest:request];
		[response release];
	}

    [self unlock];

    [storeKitRequest release];
}

-(void)dealloc
{
    [activeRequests release];
    [bufferedRequests release];
    [storeKitRequest release];
    [super dealloc];
}

@end