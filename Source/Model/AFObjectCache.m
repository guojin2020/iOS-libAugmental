#import "AFObject.h"

#import "AFObjectRequest.h"
#import "AFObjectHelper.h"
#import "AFWriteableObject.h"
#import "AFObjectCache.h"
#import "AFSession.h"
#import "AFUtil.h"
#import "AFEnvironment.h"

@implementation AFObjectCache

- (id)init
{
    if ((self = [super init]))
    {
        cache           = [[NSMutableDictionary alloc] init];
        numberFormatter = [[NSNumberFormatter alloc] init];
        //[[AFAppDelegate appEventManager] addObserver:self]; //FIX!!
    }
    return self;
}

- (NSObject <AFObject> *)objectOfType:(id<AFObject>)objectClass withPrimaryKey:(int)primaryKey
{
    NSAssert(primaryKey > 0, @"Invalid primary key calling %@", NSStringFromSelector(_cmd));
    NSAssert(objectClass, @"Invalid class calling %@", NSStringFromSelector(_cmd));

    if (primaryKey <= 0)
    {}

    NSString     *classString    = NSStringFromClass((Class)objectClass);
    NSDictionary *typeDictionary = [cache objectForKey:classString];

    //If we had a dictionary for that type, search it
    NSObject <AFObject> *findObject = nil;
    if (typeDictionary) findObject = [typeDictionary objectForKey:[NSNumber numberWithInt:primaryKey]];
    //If we had the object in the cache, return it
    if (findObject) return findObject;
    else
    {
        NSObject <AFObject> *newObject = [NSAllocateObject((Class)objectClass, 0, NULL) initPlaceholderWithPrimaryKey:primaryKey];
        [self injectObject:newObject]; //If we just created a new object, put it into the cache

        NSString        *queryString = [NSString stringWithFormat:@"?action=get%@&id=%i", (id<AFObject>)[objectClass modelName], primaryKey];
        NSURL           *callURL     = [NSURL URLWithString:queryString relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
        AFObjectRequest *request     = [[AFObjectRequest alloc] initWithURL:callURL endpoint:self];
        [[AFSession sharedSession] handleRequest:request];
        [request release];
        return newObject;
    }
}

- (void)eventOccurred:(event)type source:(NSObject *)source
{
    if (type == (event) APP_MEMORY_WARNING)
    {
        [self pruneCache];
    }
}

- (void)pruneCache
{
    NSObject <AFObject> *object;
    int retainCount;
    NSMutableSet        *keysForRemoval = [[NSMutableSet alloc] init];
    NSMutableDictionary *typeDictionary;
    for (NSString       *typeName in cache) //Iterate over each object type
    {
        typeDictionary = (NSMutableDictionary *) [cache objectForKey:typeName];
        for (NSNumber *key in typeDictionary)
        {
            object      = [typeDictionary objectForKey:key];
            retainCount = [object retainCount];
            if (retainCount == 1) [keysForRemoval addObject:key];
        }

        for (NSNumber *key in keysForRemoval)
        {
            //object = [typeDictionary objectForKey:key];
            [typeDictionary removeObjectForKey:key];
        }
    }
    [keysForRemoval release];
}

- (void)emptyCache
{
    [cache removeAllObjects];
}

- (void)emptyCacheForType:(Class)type
{
    [cache removeObjectForKey:NSStringFromClass(type)];
}

- (void)request:(NSObject <AFRequest> *)request returnedWithData:(id)data
{}

- (AFObjectRequest *)writeObject:(NSObject <AFWriteableObject> *)object endpoint:(NSObject <AFRequestEndpoint> *)endpoint
{
    NSAssert(object, @"Invalid object calling %@", NSStringFromSelector(_cmd));

    id<AFObject> objectClass = ((id<AFObject>) [object class]);
    NSString        *queryString = [NSString stringWithFormat:@"?action=put%@", [objectClass modelName]];
    NSURL           *callURL     = [NSURL URLWithString:queryString relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
    AFObjectRequest *request     = [[AFObjectRequest alloc] initWithURL:callURL AFWriteableObjects:[NSArray arrayWithObjects:object, nil] endpoint:endpoint];
    [[AFSession sharedSession] handleRequest:request];
    [request release];
    return request;
}

- (AFObjectRequest *)deleteObject:(NSObject <AFObject> *)object endpoint:(NSObject <AFRequestEndpoint> *)endpoint
{
    NSAssert(object, @"Invalid object calling %@", NSStringFromSelector(_cmd));

    id<AFObject> objectClass = ((id<AFObject>) [object class]);

    if ([object conformsToProtocol:@protocol(AFWriteableObject)])
    {
        [(NSObject <AFWriteableObject> *) object willBeDeleted];

        if ([object primaryKey] > 0)
        {
            NSMutableDictionary *typeDictionary = (NSMutableDictionary *) [cache objectForKey:NSStringFromClass((Class)objectClass)];
            [typeDictionary removeObjectForKey:[NSNumber numberWithInt:object.primaryKey]];

            NSString *queryString = [NSString stringWithFormat:@"?action=delete%@&id=%i", [objectClass modelName], [object primaryKey]];

            NSURL *callURL = [NSURL URLWithString:queryString relativeToURL:[AFSession sharedSession].environment.APIBaseURL];

            AFObjectRequest *request = [[AFObjectRequest alloc] initWithURL:callURL AFWriteableObjects:[NSArray arrayWithObjects:object, nil] endpoint:endpoint];
            [[AFSession sharedSession] handleRequest:request];
            [request release];
            return request;
        }
    }
    return nil;
}

- (BOOL)deleteObjectLocallyWithModelName:(NSString *)modelName primaryKey:(int)pk
{
    NSAssert(pk > 0, @"Invalid primary key calling %@", NSStringFromSelector(_cmd));

    NSMutableDictionary *typeDictionary = [cache objectForKey:modelName];
    NSObject            *object         = [typeDictionary objectForKey:[NSNumber numberWithInt:pk]];
    if (object)
    {
        [typeDictionary removeObjectForKey:[NSNumber numberWithInt:pk]];
        return YES;
    }
    else
    {
        return NO;
    }

}

- (NSArray *)objectsOfType:(id<AFObject>)objectClass withPrimaryKeys:(NSArray *)primaryKeys
{
    NSMutableArray *objectsOut = [NSMutableArray array];
    int primaryKey;
    NSObject <AFObject> *AFObject;
    for (int i = 0; i < [primaryKeys count]; i++)
    {
        primaryKey = [((NSNumber *) [primaryKeys objectAtIndex:i]) intValue];
        AFObject   = [self objectOfType:objectClass withPrimaryKey:primaryKey];
        [objectsOut addObject:AFObject];
    }
    return objectsOut;
}

- (BOOL)containsObjectOfType:(Class)objectClass withPrimaryKey:(int)primaryKey
{
    NSAssert(primaryKey > 0, @"Invalid primary key calling %@", NSStringFromSelector(_cmd));

    NSDictionary *typeDictionary = [cache objectForKey:NSStringFromClass(objectClass)];
    return (typeDictionary && [typeDictionary objectForKey:[NSNumber numberWithInt:primaryKey]]);
}

- (void)injectObject:(NSObject <AFObject> *)object
{
    if (object)
    {
        if ([object primaryKey] < 0)
        {
            return;
        }
        NSString            *className      = NSStringFromClass([object class]);
        NSMutableDictionary *typeDictionary = (NSMutableDictionary *) [cache objectForKey:className];
        if (!typeDictionary)
        {
            typeDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
            [cache setObject:typeDictionary forKey:className];
            [typeDictionary release];
        }
        [typeDictionary setObject:(NSObject *) object forKey:[NSNumber numberWithInt:[object primaryKey]]];
    }
}

- (NSObject <AFObject> *)objectFromDictionary:(NSDictionary *)objectDictionary
{
    NSAssert(objectDictionary && [objectDictionary isKindOfClass:[NSDictionary class]], @"Invalid dictionary calling %@ %@", NSStringFromSelector(_cmd), objectDictionary);

    if (!objectDictionary) return nil; //Return nil if we were supplied a null pointer.
    NSObject <AFObject> *object    = nil;
    NSString            *className = [[objectDictionary valueForKey:@"class"] retain]; //Get the objects model name and validate its existence
    int primaryKey = [[objectDictionary objectForKey:@"pk"] intValue];

    NSAssert(className && primaryKey > 0, primaryKey > 0 ? @"Tried to make an object from a dictionary which was missing the required 'class' key"
            : @"Tried to make an object from a dictionary which had an invalid primaryKey");

    //Get the actual class for this model name
    id<AFObject> objectClass = (id<AFObject>) [AFObjectHelper classForModelName:className];

    //If the object is already in the cache, assume it has updated content and update our existing instance
    if ([self containsObjectOfType:objectClass withPrimaryKey:primaryKey])
    {
        //Retrieve the existing instance from the cache
        object = [self objectOfType:objectClass withPrimaryKey:primaryKey];
        if (object.isPlaceholder)
        {
            //Update its content with the incoming dictionary
            [object setContentFromDictionary:objectDictionary];
        }
    }
    else //If the object isn't already in the cache....
    {
        //Initialise a new AFObject instance of the right type for the incoming dictionary
        object = NSAllocateObject((Class)objectClass, 0, NULL);
        [(NSObject <AFObject> *) object initPlaceholderWithPrimaryKey:primaryKey];

        //Register it with the cache
        [self injectObject:object];

        //Set its content from the incoming dictionary
        [object setContentFromDictionary:objectDictionary];
    }

    [className release];
    return object;
}

- (NSArray *)allocObjectsFromDictionaries:(NSArray *)objectDictionaries
{
    NSAssert(objectDictionaries && ![objectDictionaries isKindOfClass:[NSNull class]], @"No!");

    NSMutableArray *objects = [[NSMutableArray alloc] init];
    if (!objectDictionaries) return objects;
    NSMutableArray *objectsToSet = [[NSMutableArray alloc] init];
    id<AFObject> objectClass;
    for (NSDictionary *objectDictionary in objectDictionaries)
    {
        if (objectDictionary && (NSNull *) objectDictionary != [NSNull null])
        {
            NSString *className = [[objectDictionary valueForKey:@"class"] retain];
            if (className)
            {
                NSObject <AFObject> *object;
                objectClass = (id<AFObject>) [AFObjectHelper classForModelName:className];
                int primaryKey = -1;
                NSNumber *pkNumber = [objectDictionary objectForKey:@"pk"];
                if (![pkNumber isKindOfClass:[NSNull class]])
                {
                    primaryKey = [pkNumber intValue];

                    if (objectClass == NSClassFromString(@"AFAddress"))
                    {
                    }

                    if (primaryKey != -1 && [self containsObjectOfType:objectClass withPrimaryKey:primaryKey])
                    {
                        object = [self objectOfType:objectClass withPrimaryKey:primaryKey];
                        if (object.isPlaceholder)
                        {
                            [objectsToSet addObject:[NSArray arrayWithObjects:object, objectDictionary, nil]];
                        }
                    }
                    else
                    {
                        object = NSAllocateObject((Class)objectClass, 0, NULL);
                        [(NSObject <AFObject> *) object initPlaceholderWithPrimaryKey:primaryKey];
                        [self injectObject:object];
                        [objectsToSet addObject:[NSArray arrayWithObjects:object, objectDictionary, nil]];
                    }
                    if (object) [objects addObject:(NSObject *) object];
                }
            }
            [className release];
        }
    }

    NSArray      *setPair;
    NSEnumerator *enumerator     = [objectsToSet objectEnumerator];
    while ((setPair = [enumerator nextObject]))
    {
        [(NSObject <AFObject> *) [setPair objectAtIndex:0] setContentFromDictionary:(NSDictionary *) [setPair objectAtIndex:1]];
    }
    [objectsToSet release];
    return objects;
}

- (void)saveObjectToDefaults:(NSObject <NSCoding> *)obj forKey:(NSString *)key
{
    NSAssert(key && [key isKindOfClass:[NSString class]] && [key length] > 0, @"Invalid key calling %@", NSStringFromSelector(_cmd));

    NSLog(@"Saving '%@' to defaults under key '%@'", obj, key);

    NSMutableData   *objectData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver   = [[NSKeyedArchiver alloc] initForWritingWithMutableData:objectData];
    [archiver setDelegate:self];
    [archiver encodeRootObject:obj];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:objectData forKey:key];
    [archiver release];
    [objectData release];

    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"...finished saving key '%@'", key);
}

- (NSObject <NSCoding> *)loadObjectFromDefaultsForKey:(NSString *)key
{
    NSAssert(key && [key isKindOfClass:[NSString class]] && [key length] > 0, @"Invalid key calling %@", NSStringFromSelector(_cmd));

    NSLog(@"Loading key '%@' from defaults", key);

    NSData *objectData = [[NSUserDefaults standardUserDefaults] dataForKey:key];

    [AFUtil logData:objectData];

    if (objectData)
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:objectData];
        [unarchiver setDelegate:self];
        NSObject <NSCoding> *object = [unarchiver decodeObject];
        [unarchiver finishDecoding];
        [unarchiver release];

        NSLog(@"...finished loading '%@' from key '%@'", object, key);
        return object;
    }

    else return nil;
}

//========>> NSKeyedUnarchiverDelegate

- (Class)unarchiver:(NSKeyedUnarchiver *)unarchiver cannotDecodeObjectOfClassName:(NSString *)name originalClasses:(NSArray *)classNames
{
    return nil;
}

- (id)unarchiver:(NSKeyedUnarchiver *)unarchiver didDecodeObject:(id)object
{
    if (object && [object conformsToProtocol:@protocol(AFObject)])
    {
        int primaryKey = [((NSObject <AFObject> *) object) primaryKey];
        if ([self containsObjectOfType:(id<AFObject>)[object class] withPrimaryKey:primaryKey])
        {
            return [self objectOfType:(id<AFObject>)[object class] withPrimaryKey:primaryKey];
        }
        else
        {
            [self injectObject:object];
            return object;
        }
    }
    else return object;
}

- (void)unarchiver:(NSKeyedUnarchiver *)unarchiver willReplaceObject:(id)object withObject:(id)newObject
{}

- (void)unarchiverDidFinish:(NSKeyedUnarchiver *)unarchiver
{}

- (void)unarchiverWillFinish:(NSKeyedUnarchiver *)unarchiver
{}

//================>> Unarchiver delegate finish

//=====> Archiver delegate

- (void)archiver:(NSKeyedArchiver *)archiver didEncodeObject:(id)object
{}

- (id)archiver:(NSKeyedArchiver *)archiver willEncodeObject:(id)object
{return object;}

- (void)archiver:(NSKeyedArchiver *)archiver willReplaceObject:(id)object withObject:(id)newObject
{}

- (void)archiverDidFinish:(NSKeyedArchiver *)archiver
{}

- (void)archiverWillFinish:(NSKeyedArchiver *)archiver
{}

//=====> Archiver delegate finish

- (void)dealloc
{
    [numberFormatter release];
    [cache release];
    [super dealloc];
}

@end
