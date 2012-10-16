#import "AFResultsPage.h"

static NSString *RESULTS_COUNT_KEY    = @"resultsCount";
static NSString *CURRENT_PAGE_KEY     = @"currentPage";
static NSString *RESULTS_PER_PAGE_KEY = @"resultsPerPage";
static NSString *PAGE_OBJECTS_KEY     = @"pageObjects";

@implementation AFResultsPage

- (id)initWithPageObjects:(NSArray *)pageObjectsIn resultsCount:(uint16_t)resultsCountIn currentPage:(uint16_t)currentPageIn resultsPerPage:(uint16_t)resultsPerPageIn
{
    NSAssert(pageObjectsIn && resultsPerPageIn > 0, @"");

    if ((self = [self init]))
    {
        pageObjects    = [pageObjectsIn retain];
        resultsCount   = resultsCountIn;
        currentPage    = currentPageIn;
        resultsPerPage = resultsPerPageIn;
    }
    return self;
}

//======================>> NSCoding Start

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInt:resultsCount forKey:RESULTS_COUNT_KEY];
    [coder encodeInt:currentPage forKey:CURRENT_PAGE_KEY];
    [coder encodeInt:resultsPerPage forKey:RESULTS_PER_PAGE_KEY];
    [coder encodeObject:pageObjects forKey:PAGE_OBJECTS_KEY];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    if ((self = [super init]))
    {
        resultsCount   = (uint16_t) [coder decodeIntForKey:RESULTS_COUNT_KEY];
        currentPage    = (uint16_t) [coder decodeIntForKey:CURRENT_PAGE_KEY];
        resultsPerPage = (uint16_t) (uint16_t) [coder decodeIntForKey:RESULTS_PER_PAGE_KEY];
        pageObjects    = [coder decodeObjectForKey:PAGE_OBJECTS_KEY];

        NSAssert(pageObjects && resultsPerPage > 0, @"");
    }
    return self;
}

//====================== NSCoding End

- (void)dealloc
{
    [pageObjects release];
    [super dealloc];
}

@synthesize resultsCount, currentPage, resultsPerPage, pageObjects;

@end
