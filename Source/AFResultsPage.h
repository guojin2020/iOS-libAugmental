
#import <Foundation/Foundation.h>

@interface AFResultsPage : NSObject <NSCoding>
{
	uint16_t resultsCount;
	uint16_t currentPage;
	uint16_t resultsPerPage;
	
	NSArray* pageObjects;
}

-(id)initWithPageObjects:(NSArray*)pageObjectsIn resultsCount:(uint16_t)resultsCountIn currentPage:(uint16_t)currentPageIn resultsPerPage:(uint16_t)resultsPerPageIn;

@property (nonatomic, readonly) uint16_t resultsCount;
@property (nonatomic, readonly) uint16_t currentPage;
@property (nonatomic, readonly) uint16_t resultsPerPage;

@property (nonatomic, retain, readonly) NSArray* pageObjects;

@end
