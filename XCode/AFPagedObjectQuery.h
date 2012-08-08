
#import <Foundation/Foundation.h>
#import "AFRequestEndpoint.h"

@class AFSession;
@class AFResultsPage;
@class AFPagedObjectRequest;

@protocol AFPagedObjectQueryObserver;

@interface AFPagedObjectQuery : NSObject <NSCoding, AFRequestEndpoint>
{
	NSString* queryString;
	uint8_t currentPageNumber;
	uint16_t pageBy;
	NSMutableSet* observers;
	AFResultsPage* currentResultsPage;
    AFPagedObjectRequest* currentRequest;
}

-(id)initWithBaseQueryString:(NSString*)baseQueryStringIn pageBy:(uint16_t)pageByIn;

-(void)setCurrentPageNumber:(uint8_t)pageNumber;
-(void)setPageBy:(uint8_t)pageByIn;
-(void)refresh;
-(void)cancelQuery;

-(void)addObserver:(NSObject<AFPagedObjectQueryObserver>*)observer;
-(void)removeObserver:(NSObject<AFPagedObjectQueryObserver>*)observer;

@property (nonatomic) uint8_t currentPageNumber;
@property (nonatomic, readonly) NSString* queryString;

@end
