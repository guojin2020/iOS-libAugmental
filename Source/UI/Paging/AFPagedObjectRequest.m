#import "AFPagedObjectRequest.h"
#import "AFResultsPage.h"
#import "AFSession.h"
#import "AFObjectCache.h"

@implementation AFPagedObjectRequest

- (id)initWithURL:(NSURL *)URLIn endpoint:(NSObject <AFRequestEndpoint> *)endpointIn resultsPerPage:(uint16_t)resultsPerPageIn page:(uint16_t)pageIn
{
    NSAssert(endpointIn && resultsPerPageIn > 0 && pageIn > 0, @"Invalid parameters initing %@", [self class]);

    if ((self = [self initWithURL:URLIn endpoint:endpointIn]))
    {
        resultsPerPage = resultsPerPageIn;
        page           = pageIn;
    }
    return self;
}

- (void)didFinish
{
    state = (requestState) fulfilled;
    [self broadcastToObservers:(requestEvent) finished];

    NSString *responseString = [[NSString alloc] initWithData:responseDataBuffer encoding:NSUTF8StringEncoding];
    //DebugLog(@"Response from '%@': %@",[URL absoluteString],responseString);


    NSError      *error         = nil;
    NSDictionary *rootContainer = [[AFJSONRequest jsonDeserializer] deserialize:responseDataBuffer error:&error];
    //NSLog(@"%@",error);

    //NSAssert([rootContainer isKindOfClass:[NSDictionary class]],@"There was no paging data from the request '%@'",[URL absoluteString]);

    NSDictionary *pagingData         = [rootContainer objectForKey:@"pagingData"];
    NSArray      *objectDictionaries = [rootContainer objectForKey:@"pageObjects"];

    [responseString release];

    int resultsCount = [(NSNumber *) [pagingData objectForKey:@"resultsCount"] intValue];

    NSArray *pageObjects = resultsCount > 0 ? [[AFSession sharedSession].cache allocObjectsFromDictionaries:objectDictionaries] : [[NSArray alloc] init];

    AFResultsPage *resultsPage = [[AFResultsPage alloc] initWithPageObjects:pageObjects
                                                               resultsCount:resultsCount
                                                                currentPage:[(NSNumber *) [pagingData objectForKey:@"currentPage"] intValue]
                                                             resultsPerPage:[(NSNumber *) [pagingData objectForKey:@"resultsPerPage"] intValue]];

    [pageObjects release];
    [endpoint request:self returnedWithData:resultsPage];
    [resultsPage release];

    //#ifdef SHOW_SERVER_DEBUG
    NSString *debugString = [returnedDictionary objectForKey:@"debug"];
    if ([debugString isKindOfClass:[NSString class]] && [debugString length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Debug Message" message:[NSString stringWithFormat:@"%@ logged: %@", [URL absoluteString], debugString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    //#endif

    //[callbackObject performSelector:callbackSelector withObject:resultsPage];
}

- (NSString *)actionDescription
{return @"Getting search results";}

@end
