//
// Created by augmental on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFSKProductFetcher.h"

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
        idsProducts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// SKProductsRequestDelegate implementation

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{

}

- (void)requestDidFinish:(SKRequest *)request {

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {

}

@end