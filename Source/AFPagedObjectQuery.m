
#import "AFPagedObjectQuery.h"
#import "AFResultsPage.h"
#import "AFSession.h"
#import "AFEnvironment.h"
#import "AFPagedObjectQueryObserver.h"
#import "AFPagedObjectRequest.h"
//#import "AFAppDelegate.h"


@implementation AFPagedObjectQuery

-(id)initWithBaseQueryString:(NSString*)queryStringIn pageBy:(uint16_t)pageByIn;
{
	NSAssert(queryStringIn && pageByIn>0,@"Bad parameters initing a query string");
	
	if((self = [self init]))
	{
		currentPageNumber = 1;
		queryString = [queryStringIn retain];
		pageBy = pageByIn;
		observers = [[NSMutableSet alloc] init];
	}
	return self;
}

-(void)setCurrentPageNumber:(uint8_t)pageNumber
{
	if(!currentResultsPage || (pageNumber!=currentPageNumber && pageNumber>0))
	{
		NSURL* queryURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&pageBy=%i&page=%i",queryString,pageBy,pageNumber] relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
		
        AFPagedObjectRequest* oldRequest = currentRequest;
		currentRequest = [[AFPagedObjectRequest alloc] initWithURL:queryURL endpoint:self resultsPerPage:pageBy page:currentPageNumber];
        [oldRequest release];
		[[AFSession sharedSession] handleRequest:currentRequest];
		//[newPageRequest release];
		[queryURL release];
	}
}

-(void)refresh
{
	[currentResultsPage release];
	currentResultsPage=nil;
	[self setCurrentPageNumber:currentPageNumber];
}

-(void)setPageBy:(uint8_t)pageByIn
{
	pageBy = pageByIn;
	currentResultsPage=nil;
	[self setCurrentPageNumber:1];
}

-(void)cancelQuery
{
    [currentRequest release];
    currentRequest = nil;
}

-(void)addObserver:(NSObject<AFPagedObjectQueryObserver>*)observer{[observers addObject:observer];}
-(void)removeObserver:(NSObject<AFPagedObjectQueryObserver>*)observer{[observers removeObject:observer];}

-(void)request:(NSObject<AFRequest>*)request returnedWithData:(id)resultsPage
{
    if(request==currentRequest)
    {
        [currentRequest release];
        currentRequest = nil;
        
        AFResultsPage* oldResultsPage = (AFResultsPage*)resultsPage;
        currentResultsPage = [resultsPage retain];
        currentPageNumber = currentResultsPage.currentPage;
        [oldResultsPage release];
        for(NSObject<AFPagedObjectQueryObserver>* observer in observers) [observer resultsPageUpdated:resultsPage];
    }
}

//==================================>> NSCoding

-(void)encodeWithCoder:(NSCoder*)coder;
{
	[coder encodeObject:queryString forKey:@"queryString"];
	[coder encodeInt:currentPageNumber forKey:@"currentPageNumber"];
	[coder encodeInt:pageBy forKey:@"currentPageNumber"];
}

-(id)initWithCoder:(NSCoder*)coder;
{
    if((self = [super init]))
    {
		queryString			= [[coder decodeObjectForKey:@"queryString"] retain];
		currentPageNumber	= [coder decodeIntForKey:@"currentPageNumber"];
		pageBy				= [coder decodeIntForKey:@"pageBy"];
		
		observers = [[NSMutableSet alloc] init];
		currentResultsPage = nil;
		[self setCurrentPageNumber:currentPageNumber];
    }
	return self;
}

//====================== NSCoding


-(void)dealloc
{
	[observers release];
    [queryString release];
    [currentRequest release];
    [currentResultsPage release];
    [queryString release];
    [super dealloc];
}

@synthesize currentPageNumber, queryString;

@end
