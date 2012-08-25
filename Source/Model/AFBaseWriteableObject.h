#import <Foundation/Foundation.h>
#import "AFBaseObject.h"
#import "AFRequestEndpoint.h"

@interface AFBaseWriteableObject : AFBaseObject
{}

- (NSMutableDictionary *)setDictionaryFromContent:(NSMutableDictionary *)dictionary;

/**
 Convenience method which writes this object back to the server using the object cache of the current shared AFSession.
 Equivalent to calling: [[AFSession sharedSession].cache writeObject:self endpoint:endpointIn];
 */
- (AFObjectRequest *)writeWithEndpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

@end
