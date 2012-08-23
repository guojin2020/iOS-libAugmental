
#import <Foundation/Foundation.h>
#import "AFObjectRequest.h"

@protocol AFRequestEndpoint;

@interface AFPagedObjectRequest : AFObjectRequest
{
	uint16_t resultsPerPage;
	uint16_t page;
}

-(id)initWithURL:(NSURL*)URLIn endpoint:(NSObject<AFRequestEndpoint>*)endpointIn resultsPerPage:(uint16_t)resultsPerPageIn page:(uint16_t)pageIn;

@end
