
#import "AFEnvironment.h"

static AFEnvironment* liveEnvironment = nil;
static AFEnvironment* devEnvironment	 = nil;

@implementation AFEnvironment

+(AFEnvironment*)liveEnvironment
{
	if(!liveEnvironment) liveEnvironment = [[AFEnvironment alloc] initWithAPI:[NSURL URLWithString:@"http://www.networkdvd.net/mobile/"]
															 productImageBaseURL:[NSURL URLWithString:@"http://www.networkdvd.net/images/"]
																paypalNotificationURL:[NSURL URLWithString:@"http://www.networkdvd.net/mobile/paypal_notify.php"]];
	return liveEnvironment;
}

+(AFEnvironment*)devEnvironment
{
	if(!devEnvironment) devEnvironment = [[AFEnvironment alloc] initWithAPI:[NSURL URLWithString:@"http://chrishatton.homeip.net/networkdvd/"]
														   productImageBaseURL:[NSURL URLWithString:@"http://www.networkdvd.net/images/"]
															  paypalNotificationURL:[NSURL URLWithString:@"http://chrishatton.homeip.net/networkdvd/paypal_notify.php"]];
	return devEnvironment;
}

-(id)initWithAPI:(NSURL*)APIBaseURLIn productImageBaseURL:(NSURL*)productImageBaseURLIn paypalNotificationURL:(NSURL*)paypalNotificationURLIn
{
	NSAssert(APIBaseURLIn && productImageBaseURLIn && paypalNotificationURLIn,@"Invalid parameters to init Environment");
	
	if((self = [super init]))
	{
		APIBaseURL = [APIBaseURLIn retain];
		productImageBaseURL = [productImageBaseURLIn retain];
		paypalNotificationURL = [paypalNotificationURLIn retain];
	}
	return self;
}

-(void)dealloc
{
	[APIBaseURL release];
	[productImageBaseURL release];
	[super dealloc];
}

@synthesize APIBaseURL,productImageBaseURL,paypalNotificationURL;

@end
