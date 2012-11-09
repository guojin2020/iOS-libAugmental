//
// Created by augmental on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
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

- (id)init
{
    self = [super init];
    if (self)
    {
        bufferedRequests    = [[NSMutableSet alloc] init];
        activeRequests      = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)lock
{
    ++bufferLockCount;
}

- (void)unlock
{
    if(bufferLockCount>0)
    {
        --bufferLockCount;
        if(bufferLockCount==0)
        {
            [self sendRequests];
        }
    }
}

-(void)sendRequests
{
    NSAssert([activeRequests count]==0,@"There should never be any active requests when sendRequests is invoked.");

    if([bufferedRequests count]==0) return;

    NSMutableSet *swapSet = activeRequests;
    activeRequests   = bufferedRequests;
    bufferedRequests = swapSet;

    NSMutableSet *productIds = [[NSMutableSet alloc] init];
    for(AFSKProductRequest *activeRequests)

    [[SKProductsRequest alloc] initWithProductIdentifiers:<#(NSSet *)productIdentifiers#>]
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
            if([request.productId isEqualToString:product.productIdentifier])
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
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self unlock];
}

-(void)dealloc
{
    [activeRequests release];
    [bufferedRequests release];
    [super dealloc];
}


@end