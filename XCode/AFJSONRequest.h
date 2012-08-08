
//Represents a request for data from a URL, whose completion will trigger the specified callback

#import "AFBaseRequest.h"
#import "AFRequest.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"

@class AFSession;
@protocol AFRequestEndpoint;

@interface AFJSONRequest : AFBaseRequest <AFRequest>
{
	NSObject<AFRequestEndpoint>* endpoint;
	NSMutableData* responseDataBuffer;
	NSData* postData;
	NSDictionary* returnedDictionary;
}

+(CJSONDeserializer*)jsonDeserializer;
+(CJSONSerializer*)jsonSerializer;

-(NSData*)receivedData;
-(NSData*)postData;
-(NSString*)newPostDataString;

-(id)initWithURL:(NSURL*)URLIn endpoint:(NSObject<AFRequestEndpoint>*)endpointIn;
-(id)initWithURL:(NSURL*)URLIn Dictionary:(NSDictionary*)postDictionary endpoint:(NSObject<AFRequestEndpoint>*)endpointIn;

@property (nonatomic, retain, readonly) NSDictionary* returnedDictionary;

@end
