#import "AFHeaderRequest.h"
#import "AFRequestEndpoint.h"

@implementation AFHeaderRequest

-(id)initWithURL:(NSURL*)URLIn endpoint:(NSObject<AFRequestEndpoint>*)endpointIn
{
	NSAssert(endpointIn,@"No endpoint was specified for a header request.");
	
	if((self = [super initWithURL:(NSURL*)URLIn]))
	{
		self.endpoint = endpointIn;
	}
	return self;
}

-(NSMutableURLRequest*)willSendURLRequest:(NSMutableURLRequest*)requestIn
{
    [super willSendURLRequest:requestIn];
    
	[requestIn setHTTPMethod:@"HEAD"];
	return requestIn;
}

-(void)willReceiveWithHeaders:(NSDictionary*)headersIn responseCode:(int)responseCode
{
	self.headers = headersIn;
	[super willReceiveWithHeaders:headers responseCode:responseCode];
	
}

-(void)didFinish
{
	[super didFinish];
	[endpoint request:self returnedWithData:headers];
}

-(void)didFail:(NSError*)error
{
}

-(NSString*)actionDescription{return @"Determining download size";}

- (void)dealloc {
    [endpoint release];
    [headers release];
    [super dealloc];
}

@synthesize endpoint, headers;
@dynamic connection, URL, state, requiresLogin, attempts;

@end
