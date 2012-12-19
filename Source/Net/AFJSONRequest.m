//Represents a request for data from a URL, whose completion will trigger the specified callback

#import "AFObservable.h"
#import "AFJSONRequest.h"
#import "AFRequestEndpoint.h"
#import "CJSONDeserializer_BlocksExtensions.h"
#import "CJSONSerializer.h"

#define SHOW_SERVER_DEBUG
#define SHOW_SERVER_ERROR

static CJSONDeserializer *jsonDeserializer;
static CJSONSerializer   *jsonSerializer;

@implementation AFJSONRequest

+ (void)initialize
{
    jsonDeserializer = [[CJSONDeserializer deserializer] retain];
    jsonSerializer   = [[CJSONSerializer serializer] retain];
}

+ (CJSONDeserializer *)jsonDeserializer { return jsonDeserializer; }

+ (CJSONSerializer *)jsonSerializer { return jsonSerializer; }

- (id)initWithURL:(NSURL *)URLIn endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    NSAssert(endpointIn, @"Invalid parameters when initing %@", [self class]);

    if ((self = [super initWithURL:URLIn]))
    {
        endpoint           = [endpointIn retain];
        responseDataBuffer = [[NSMutableData alloc] initWithLength:0];
        postData           = nil;
        returnedDictionary = nil;
    }
    return self;
}

- (id)initWithURL:(NSURL *)URLIn Dictionary:(NSDictionary *)postDictionary endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    NSAssert(postDictionary && endpointIn, @"Invalid parameters when initing %@", [self class]);

    if ((self = [self initWithURL:URLIn endpoint:endpointIn]))
    {
        postData = [[[AFJSONRequest jsonSerializer] serializeDictionary:postDictionary error:nil] retain];
        NSAssert(postData, @"Serialisation AFSessionStateError");
    }
    return self;
}

- (NSString *)newPostDataString
{
    return [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
}

- (NSMutableURLRequest *)willSendURLRequest:(NSMutableURLRequest *)requestIn;
{
    [super willSendURLRequest:requestIn];

    //NSAssert(postData,@"Serialisation AFSessionStateError in %@, request was: %@",[self class],[URL absoluteString]);

    [requestIn setHTTPMethod:@"POST"];
    [requestIn setHTTPBody:postData];

    return requestIn;
}

- (void)willReceiveWithHeaders:(NSDictionary *)headers responseCode:(int)responseCodeIn
{
    [super willReceiveWithHeaders:headers responseCode:responseCodeIn];
    [responseDataBuffer setLength:0];
}

- (void)received:(NSData *)dataIn
{
    [super received:dataIn];
    if ((state = (AFRequestState) AFRequestStateInProcess))
    {[responseDataBuffer appendData:dataIn];}
}

- (NSData *)receivedData
{
    if (state == (AFRequestState) AFRequestStateFulfilled) return responseDataBuffer;
    return nil;
}

- (NSData *)postData
{
    if (state == (AFRequestState) AFRequestStateFulfilled) return responseDataBuffer;
    return nil;
}

- (void)didFinish
{
    [super didFinish];

    NSString *dumpString = [[NSString alloc] initWithData:responseDataBuffer encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",[NSString stringWithFormat:@"Response from '%@': %@",[[self URL] absoluteString],dumpString]);
    [dumpString release];

    NSError *error = nil;
    returnedDictionary = [[[AFJSONRequest jsonDeserializer] deserialize:responseDataBuffer error:&error] retain];

    if (error)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseDataBuffer encoding:NSUTF8StringEncoding];
        [NSException raise:NSInternalInconsistencyException format:@"Deserialisation AFSessionStateError in %@\nRequest URL was: %@\nData was: %@", [error localizedDescription], [URL absoluteString], responseString];
        //[responseString release];
        [responseString release];
    }

    if (endpoint)
    {
        //#ifdef SHOW_SERVER_DEBUG
        NSString *debugString = [returnedDictionary objectForKey:@"debug"];
        if ([debugString isKindOfClass:[NSString class]] && [debugString length] > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Debug Message" message:[NSString stringWithFormat:@"%@ logged: %@", [URL absoluteString], debugString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        //#endif

        //#ifdef SHOW_SERVER_ERROR
        NSString *errorString = [returnedDictionary objectForKey:@"AFSessionStateError"];
        if ([errorString isKindOfClass:[NSString class]] && [errorString length] > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error Message" message:[NSString stringWithFormat:@"%@ logged: %@", [URL absoluteString], errorString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        //#endif

        [endpoint request:self returnedWithData:returnedDictionary];
    }
    else
    {
        //NSString* dumpString = [[NSString alloc] initWithData:responseDataBuffer encoding:NSUTF8StringEncoding];
        //[dumpString release];
    }
}

- (NSString *)actionDescription
{return @"Getting data";}

- (void)dealloc
{
    [responseDataBuffer release];
    [endpoint release];
    [returnedDictionary release];
    [postData release];
    [postData release];
    [super dealloc];
}

@synthesize returnedDictionary;
//@dynamic requiresLogin, attempts;

//connection, URL, state

@end
