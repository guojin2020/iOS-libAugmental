//Holds recently accessed AFObjects, sorted by type and primary key. Responsible for initing requested objects that are not currently held

#import <Foundation/Foundation.h>
#import "AFRequestEndpoint.h"

@class AFWriteableObject;

@class AFObjectRequest;
@class AFSession;
@class AFObject;

/**
 AFObjectCache could be described as the most important and central class to the entire application.
 It's purpose is to service requests for any AFObject by primaryKey, which it does either by returning an already
 cached instance or by creating a placeholder instance. Both would be returned instantly by
 AFObjectCache, the difference is that when a placeholder is returned, AFObject cacheImage automatically makes the
 necessary server call to get the real information for that object and update it asynchronously. When it does so, an
 objectEvent will inform observing users of that object.
 */
/* DEPRECATED_ATTRIBUTE */
@interface AFObjectCache : NSObject <NSKeyedArchiverDelegate, NSKeyedUnarchiverDelegate, AFRequestEndpoint>
{
    NSCache *cache;
    NSNumberFormatter   *numberFormatter;
}

/**
 Retrieves a AFObject by primaryKey, either by returning an already
 cached instance or a newly created placeholder instance. Both are returned instantly by
 AFObjectCache, and if a placeholder is returned, AFObject cacheImage automatically makes the
 necessary server call to get the real information for that object before updating it asynchronously.
 When it does so, an objectEvent will inform observing users of that object.
 */
- (AFObject*)objectOfType:(Class)objectClass withPrimaryKey:(int)primaryKey;

/**
 Writes the specified object to the server. The endpoint receives the servers response to the write operation,
 which is typically the same object data with a newly assigned primary key.
 */
- (AFObjectRequest *)writeObject:(AFWriteableObject*)object endpoint:(NSObject <AFRequestEndpoint> *)endpoint;

/**
 Causes the specified object to be deleted from the server. When the server responds with a successful deletion,
 AFObjectRequest will call deleteObjectLocallyWithModelName to remove it from the local cacheImage as well.
 Returns the AFObjectRequest used to communicate this request to the server.
 */
- (AFObjectRequest *)deleteObject:(AFObject*)object endpoint:(NSObject <AFRequestEndpoint> *)endpoint;

/**
 Efficiency method to allow multiple objects to be retrieved in a single server request.
 */
- (NSArray *)objectsOfType:(AFObject*)objectClass withPrimaryKeys:(NSArray *)primaryKeys;

/**
 Returns true if an object of the given type and primary key is already held in the local cacheImage, false otherwise.
 */
- (BOOL)containsObjectOfType:(Class)objectClass withPrimaryKey:(int)primaryKey;

/**
 Where AFObjects are acquired from the server by means other than a direct primary key reference (e.g. a server API call for name searching),
 AFObjectCache provides this method to inject those objects into the cacheImage so that subsequent primary key requests for that
 same object will be serviced more efficiently.
 */
- (void)injectObject:(AFObject*)object;

/**
 Removes the object uniquely identified by the given model name and primary key.
 */
- (BOOL)deleteObjectLocallyWithModelName:(NSString *)modelName primaryKey:(int)pk;

-(void)handleAppMemoryWarning;

/**
 Releases all objects in the cacheImage which have a retain count of 1 (meaning the cacheImage is the only referrer).
 */
- (void)pruneCache;

/**
 Releases all objects in the cacheImage.
 */
- (void)emptyCache;

/**
 Releases all objects in the cacheImage of a given type.
 */
- (void)emptyCacheForType:(Class)type;

/**
 Returns an AFObject from its Dictionary representation.
 This method will use an existing cached instance of object wherever possible; such that if an object
 array is received from server, representing an object which is currently being displayed on
 the iPhone screen, the existing instance will remain in place and have its content updated with
 that from the incoming array. This has the effect of maintaining consistent instances of
 objects on the server so that observers receive those updates seamlessly.
 */
- (AFObject*)objectFromDictionary:(NSDictionary *)objectDictionary;

/**
 Allocates and initialises an array of AFObjects, from their Dictionary representations.
 */
- (NSArray *)allocObjectsFromDictionaries:(NSArray *)objectDictionaries;

/**
 Utility method to save any NSCoding compliant object graph to the NSUserDefaults persistent storage.
 It's primary use lies within AFObject cacheImage, for persisting cached AFObjects between application runs.
 */
- (void)saveObjectToDefaults:(NSObject <NSCoding> *)obj forKey:(NSString *)key;

/**
 This method loads and returns a named object graph from NSUserDefaults persistent storage. As traverses the
 object graph, will inject all AFObject compliant objects into this instance of AFObjectCache.
 It's primary use, as the counterpart for saveObject:forKey:, is to restore persisted, cached AFObjects from
 a previous application run.
 */
- (NSObject <NSCoding> *)loadObjectFromDefaultsForKey:(NSString *)key;

@end
