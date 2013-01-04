#import <Foundation/Foundation.h>
#import "AFObject.h"
#import "AFRequestEndpoint.h"

@interface AFWriteableObject : AFObject
{}

- (NSMutableDictionary *)setDictionaryFromContent:(NSMutableDictionary *)dictionary;

/**
 Convenience method which writes this object back to the server using the object cacheImage of the current shared AFSession.
 Equivalent to calling: [[AFSession sharedSession].cacheImage writeObject:self endpoint:endpointIn];
 */
- (AFObjectRequest *)writeWithEndpoint:(NSObject <AFRequestEndpoint> *)endpointIn;

-(void)willBeDeleted;

@end
