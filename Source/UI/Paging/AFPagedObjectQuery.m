#import "AFPagedObjectQuery.h"
#import "AFResultsPage.h"
#import "AFObservable.h"
#import "AFSession.h"
#import "AFEnvironment.h"
#import "AFPagedObjectQueryObserver.h"
#import "AFPagedObjectRequest.h"

@implementation AFPagedObjectQuery

- (id)initWithBaseQueryString:(NSString *)queryStringIn pageBy:(uint16_t)pageByIn;
{
    NSAssert(queryStringIn && pageByIn > 0, @"Bad parameters initing a query string");

    self = [self init];
    if (self)
    {
        currentPageNumber = 1;
        queryString       = queryStringIn;
        pageBy            = pageByIn;
        observers         = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)setCurrentPageNumber:(uint8_t)pageNumber
{
    if (!currentResultsPage || (pageNumber != currentPageNumber && pageNumber > 0))
    {
        NSURL *queryURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&pageBy=%i&page=%i", queryString, pageBy, pageNumber] relativeToURL:[AFSession sharedSession].environment.APIBaseURL];

        //AFPagedObjectRequest *oldRequest = currentRequest;
        currentRequest = [[AFPagedObjectRequest alloc] initWithURL:queryURL endpoint:self resultsPerPage:pageBy page:currentPageNumber];
        [[AFSession sharedSession] handleRequest:currentRequest];
        //[newPageRequest release];
    }
}

- (void)refresh
{
    currentResultsPage = nil;
    [self setCurrentPageNumber:currentPageNumber];
}

- (void)setPageBy:(uint8_t)pageByIn
{
    pageBy = pageByIn;
    currentResultsPage = nil;
    [self setCurrentPageNumber:1];
}

- (void)cancelQuery
{
    currentRequest = nil;
}

- (void)addObserver:(NSObject <AFPagedObjectQueryObserver> *)observer
{[observers addObject:observer];}

- (void)removeObserver:(NSObject <AFPagedObjectQueryObserver> *)observer
{[observers removeObject:observer];}

- (void)request:(AFRequest*)request returnedWithData:(id)resultsPage
{
    if (request == currentRequest)
    {
        currentRequest = nil;

        AFResultsPage *oldResultsPage = (AFResultsPage *) resultsPage;
        currentResultsPage = resultsPage;
        currentPageNumber  = (uint8_t) currentResultsPage.currentPage;
        for (NSObject <AFPagedObjectQueryObserver> *observer in observers) [observer resultsPageUpdated:resultsPage];
    }
}

//==================================>> NSCoding

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:queryString forKey:@"queryString"];
    [coder encodeInt:currentPageNumber forKey:@"currentPageNumber"];
    [coder encodeInt:pageBy forKey:@"currentPageNumber"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [self init];
    if (self)
    {
        queryString       = [coder decodeObjectForKey:@"queryString"];
        currentPageNumber = (uint8_t) [coder decodeIntForKey:@"currentPageNumber"];
        pageBy            = (uint16_t) [coder decodeIntForKey:@"pageBy"];

        observers          = [[NSMutableSet alloc] init];
        currentResultsPage = nil;
        [self setCurrentPageNumber:currentPageNumber];
    }
    return self;
}

- (void)requestFailed:(AFRequest *)request withError:(NSError*)errorIn
{

}


@synthesize currentPageNumber, queryString;

@end
