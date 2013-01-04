#import "AFWriteableObject.h"

static NSString *PRIMARY_KEY_KEY = @"pk";
static NSString *CLASS_KEY       = @"class";

@implementation AFWriteableObject

- (NSMutableDictionary *)setDictionaryFromContent:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:[NSNumber numberWithInt:primaryKey] forKey:PRIMARY_KEY_KEY];
    [dictionary setObject:[[self class] modelName] forKey:CLASS_KEY];
    return dictionary;
}

- (AFObjectRequest *)writeWithEndpoint:(NSObject <AFRequestEndpoint> *)endpointIn
{
    return nil;

    //return [[AFSession sharedSession].cacheImage writeObject:(NSObject<AFWriteableObject>*)self endpoint:endpointIn];
}

- (void)willBeDeleted
{

}


@end
