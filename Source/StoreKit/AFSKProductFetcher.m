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

@interface AFSKProductFetcher ()

- (void)sendRequests;

@end

@implementation AFSKProductFetcher
{
}

static AFSKProductFetcher *sharedInstance;

+(AFSKProductFetcher *)sharedInstance
{
    return sharedInstance ?: (sharedInstance = [[AFSKProductFetcher alloc] init]);
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

-(AFSKProductRequest*)requestProductForConsumer:(id<AFPSKProductConsumer>)consumer
{
    AFSKProductRequest *request = [[AFSKProductRequest alloc] initWithConsumer:consumer];
    [bufferedRequests addObject:request];
    [request release];

    if (bufferLockCount==0) [self sendRequests];

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

    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    [productIds release];

    request.delegate = self;
    [request start];
}

// SKProductsRequestDelegate implementation

- (void)productsRequest:(SKProductsRequest *)storeKitRequest didReceiveResponse:(SKProductsResponse *)storeKitResponse
{
    BOOL found;
    AFSKProductRequest *request;
    AFSKProductFetchResponse *response;

    for(SKProduct* product in storeKitResponse.products)
    {
        found = NO;
        for(request in activeRequests)
        {
            if([request.productConsumer.storeKitProductId isEqualToString:product.productIdentifier])
            {
                found = YES;

                response = [[AFSKProductFetchResponseSuccess alloc] initWithProduct:product];
                [request.productConsumer didReceiveResponse:response toRequest:request];
                [response release];
            }
        }

        if(found) [activeRequests removeObject:request];
    }

    for(request in activeRequests)
    {
        response = [[AFSKProductFetchResponseFailed alloc] initWithReason:@"Was not returned by iTunes"];
        [request.productConsumer didReceiveResponse:response toRequest:request];
        [response release];
    }

    [activeRequests removeAllObjects];

    [self unlock];
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)request:(SKRequest *)storeKitRequest didFailWithError:(NSError *)error
{
	AFSKProductRequest *request;
	AFSKProductFetchResponse *response;

	for(request in activeRequests)
	{
		response = [[AFSKProductFetchResponseFailed alloc] initWithReason:@"Could not contact iTunes"];
		[request.productConsumer didReceiveResponse:response toRequest:request];
		[response release];
	}

    [self unlock];

}

-(void)dealloc
{
    [activeRequests release];
    [bufferedRequests release];
    [super dealloc];
}


@end