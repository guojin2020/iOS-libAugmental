//Represents a request for data from a URL, whose completion will trigger the specified callback


#import "AFObjectRequest.h"
#import "AFSession.h"
#import "AFLegacyObjectCache.h"
#import "AFWriteableObject.h"

@implementation AFObjectRequest

- (id)initWithURL:(NSURL *)URLIn AFWriteableObjects:(NSArray *)postObjects endpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    NSAssert(postObjects && [postObjects count] > 0, @"Invalid parameters when initing %@", [self class]);

    if ((self = [self initWithURL:URLIn endpoint:endpointIn]))
    {
        NSMutableArray                    *objectDictionaries = [NSMutableArray arrayWithCapacity:[postObjects count]];
        for (NSObject <AFWriteableObject> *postObject in postObjects)
        {
            [objectDictionaries addObject:[postObject setDictionaryFromContent:[NSMutableDictionary dictionary]]];
        }
        NSDictionary                      *postDictionary     = [NSDictionary dictionaryWithObject:objectDictionaries forKey:@"objects"];

        postData = [[[AFJSONRequest jsonSerializer] serializeDictionary:postDictionary error:nil] retain];

        NSString *postString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        [postString release];

        NSAssert(postData, @"Deserialisation AFSessionStateError in %@, request was: %@", [self class], [URL absoluteString]);
    }
    return self;
}

- (void)didFinish
{
    state = (AFRequestState) AFRequestStateFulfilled;
    [self broadcastToObservers:(AFRequestEvent) AFRequestEventFinished];

    NSError *error = nil;
    returnedDictionary = [[[AFJSONRequest jsonDeserializer] deserialize:responseDataBuffer error:&error] retain];

    NSArray *objectDictionaries = [returnedDictionary objectForKey:@"objects"];

    if (error || !objectDictionaries || [objectDictionaries isKindOfClass:[NSNull class]])
    {
        NSString *responseString = [[NSString alloc] initWithData:responseDataBuffer encoding:NSUTF8StringEncoding];
        [NSException raise:NSInternalInconsistencyException format:@"Deserialisation AFSessionStateError in %@\nRequest URL was: %@\nData was: %@", [error localizedDescription], [URL absoluteString], responseString];
        //[responseString release];
        [responseString release];
    }

    NSArray *deleteObjects = [returnedDictionary objectForKey:@"delete"];

    if (deleteObjects && [deleteObjects count] > 0)
    {
        NSString *modelName;
        int  pk;
        BOOL success;
        for (NSDictionary *deleteSpec in deleteObjects)
        {
            modelName = (NSString *) [deleteSpec objectForKey:@"modelName"];
            pk        = [(NSNumber *) [deleteSpec objectForKey:@"pk"] intValue];
            success   = [(NSNumber *) [deleteSpec objectForKey:@"success"] boolValue];

            if (success && modelName && pk > 0)[[AFSession sharedSession].cache deleteObjectLocallyWithModelName:modelName primaryKey:pk];
        }
    }

    NSString *errorString = [returnedDictionary objectForKey:@"AFSessionStateError"];
    if (errorString)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

    NSArray *objects = [[AFSession sharedSession].cache allocObjectsFromDictionaries:objectDictionaries];

#ifdef SHOW_SERVER_DEBUG
    NSString *debugString = [returnedDictionary objectForKey:@"debug"];
    if ([debugString isKindOfClass:[NSString class]] && [debugString length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Debug Message" message:[NSString stringWithFormat:@"%@ logged: %@", [URL absoluteString], debugString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
#endif

    [endpoint request:self returnedWithData:objects];
    [objects release];
}

- (NSString *)actionDescription
{return @"Getting object data";}

//@dynamic connection, URL, state, requiresLogin, attempts;

@end
