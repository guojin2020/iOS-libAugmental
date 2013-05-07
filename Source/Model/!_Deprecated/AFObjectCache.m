#import "AFObject.h"

#import "AFObjectRequest.h"
#import "AFObjectHelper.h"
#import "AFWriteableObject.h"
#import "AFObjectCache.h"
#import "AFSession.h"
#import "AFUtil.h"
#import "AFEnvironment.h"
#import "AFLog.h"

@implementation AFObjectCache

- (id)init
{
    if ((self = [super init]))
    {
        cache           = [NSCache new];
        numberFormatter = [NSNumberFormatter new];
        //[[AFAppDelegate appEventManager] addObserver:self]; //FIX!!
    }
    return self;
}

- (AFObject*)objectOfType:(Class)objectClass withPrimaryKey:(int)primaryKey
{
    NSAssert(primaryKey > 0, @"Invalid primary key calling %@", NSStringFromSelector(_cmd));
    NSAssert(objectClass, @"Invalid class calling %@", NSStringFromSelector(_cmd));

    NSString     *classString    = NSStringFromClass((Class)objectClass);
    NSDictionary *typeDictionary = [cache objectForKey:classString];

    //If we had a array for that type, search it
    AFObject* findObject = nil;
    if (typeDictionary) findObject = [typeDictionary objectForKey:[NSNumber numberWithInt:primaryKey]];
    //If we had the object in the cacheImage, return it
    if (findObject) return findObject;
    else
    {
        AFObject* newObject = [NSAllocateObject((Class)objectClass, 0, NULL) initPlaceholderWithPrimaryKey:primaryKey];
        [self injectObject:newObject]; //If we just created a new object, put it into the cacheImage

        NSString        *queryString = [NSString stringWithFormat:@"?action=get%@&id=%i", (AFObject*)[objectClass modelName], primaryKey];
        NSURL           *callURL     = [NSURL URLWithString:queryString relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
        AFObjectRequest *request     = [[AFObjectRequest alloc] initWithURL:callURL endpoint:self];
        [[AFSession sharedSession] handleRequest:request];
        [request release];
        return newObject;
    }
}

-(void)handleAppMemoryWarning
{
    AFLogPosition();
    [self pruneCache];
}

- (void)pruneCache
{
	/*
    AFObject* object;
    int retainCount;
    NSMutableSet *keysForRemoval = [[NSMutableSet alloc] init];
    NSCache *typeCache;
    for (NSString *typeName in []) //Iterate over each object type
    {
        typeCache = [cache objectForKey:typeName];
        for (NSNumber *key in typeCache)
        {
            object      = [typeCache objectForKey:key];
            retainCount = [object retainCount];
            if (retainCount == 1) [keysForRemoval addObject:key];
        }

        for (NSNumber *key in keysForRemoval)
        {
            [typeCache removeObjectForKey:key];
        }
    }
    [keysForRemoval release];
    */
}

- (void)emptyCache
{
    [cache removeAllObjects];
}

- (void)emptyCacheForType:(Class)type
{
    [cache removeObjectForKey:NSStringFromClass(type)];
}

- (void)request:(AFRequest*)request returnedWithData:(id)data
{
    // Worrying that this is unimplemented, wasn't it supposed to be here, deserialize the JSON and insert into Cache?
}

- (void)requestFailed:(AFRequest *)request withError:(NSError*)errorIn
{
    AFLogPosition();
}

- (AFObjectRequest *)writeObject:(AFWriteableObject*)object endpoint:(NSObject <AFRequestEndpoint> *)endpoint
{
    NSAssert(object, @"Invalid object calling %@", NSStringFromSelector(_cmd));

    Class objectClass = [object class];
    NSString        *queryString = [NSString stringWithFormat:@"?action=put%@", [objectClass modelName]];
    NSURL           *callURL     = [NSURL URLWithString:queryString relativeToURL:[AFSession sharedSession].environment.APIBaseURL];
    AFObjectRequest *request     = [[AFObjectRequest alloc] initWithURL:callURL AFWriteableObjects:[NSArray arrayWithObjects:object, nil] endpoint:endpoint];
    [[AFSession sharedSession] handleRequest:request];
    [request release];
    return request;
}

- (AFObjectRequest *)deleteObject:(AFObject*)object endpoint:(NSObject <AFRequestEndpoint> *)endpoint
{
    NSAssert(object, @"Invalid object calling %@", NSStringFromSelector(_cmd));

    Class objectClass = [object class];

    if ([object isKindOfClass:[AFWriteableObject class]])
    {
        [(AFWriteableObject*)object willBeDeleted];

        if ([object primaryKey] > 0)
        {
            NSCache *typeDictionary = (NSCache *) [cache objectForKey:NSStringFromClass((Class)objectClass)];
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

    NSCache *typeDictionary = [cache objectForKey:modelName];
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

- (NSArray *)objectsOfType:(Class)objectClass withPrimaryKeys:(NSArray *)primaryKeys
{
    NSMutableArray *objectsOut = [NSMutableArray array];
    int primaryKey;
    AFObject* AFObject;
    for (NSUInteger i = 0; i < [primaryKeys count]; i++)
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

    NSDictionary *typeDictionary = [cache objectForKey:NSStringFromClass((Class)objectClass)];
    return (typeDictionary && [typeDictionary objectForKey:[NSNumber numberWithInt:primaryKey]]);
}

- (void)injectObject:(AFObject*)object
{
    if (object)
    {
        if ([object primaryKey] < 0)
        {
            return;
        }
        NSString            *className      = NSStringFromClass([object class]);
        NSCache *typeCache = (NSCache *) [cache objectForKey:className];
        if (!typeCache)
        {
            typeCache = [NSCache new];
	        [cache setObject:typeCache forKey:className];
            [typeCache release];
        }
        [typeCache setObject:object forKey:[NSNumber numberWithInt:[object primaryKey]]];
    }
}

- (AFObject*)objectFromDictionary:(NSDictionary *)objectDictionary
{
    NSAssert(objectDictionary && [objectDictionary isKindOfClass:[NSDictionary class]], @"Invalid array calling %@ %@", NSStringFromSelector(_cmd), objectDictionary);

    if (!objectDictionary) return nil; //Return nil if we were supplied a null pointer.
    AFObject* object    = nil;
    NSString            *className = [[objectDictionary valueForKey:@"class"] retain]; //Get the objects model name and validate its existence
    int primaryKey = [[objectDictionary objectForKey:@"pk"] intValue];

    NSAssert(className && primaryKey > 0, primaryKey > 0 ? @"Tried to make an object from a array which was missing the required 'class' key"
            : @"Tried to make an object from a array which had an invalid primaryKey");

    //Get the actual class for this model name
    Class objectClass = [AFObjectHelper classForModelName:className];

    //If the object is already in the cacheImage, assume it has updated content and update our existing instance
    if ([self containsObjectOfType:objectClass withPrimaryKey:primaryKey])
    {
        //Retrieve the existing instance from the cacheImage
        object = [self objectOfType:objectClass withPrimaryKey:primaryKey];
        if (object.isPlaceholder)
        {
            //Update its content with the incoming array
            [object setContentFromDictionary:objectDictionary];
        }
    }
    else //If the object isn't already in the cacheImage....
    {
        //Initialise a new AFObject instance of the right type for the incoming array
        object = NSAllocateObject((Class)objectClass, 0, NULL);
        [object initPlaceholderWithPrimaryKey:primaryKey];

        //Register it with the cacheImage
        [self injectObject:object];

        //Set its content from the incoming array
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
    Class objectClass;
    for (NSDictionary *objectDictionary in objectDictionaries)
    {
        if (objectDictionary && (id)objectDictionary != [NSNull null])
        {
            NSString *className = [[objectDictionary valueForKey:@"class"] retain];
            if (className)
            {
                AFObject* object;
                objectClass = [AFObjectHelper classForModelName:className];
                int primaryKey;
                NSNumber *pkNumber = [objectDictionary objectForKey:@"pk"];
                if (![pkNumber isKindOfClass:[NSNull class]])
                {
                    primaryKey = [pkNumber intValue];

                    if ((Class)objectClass == NSClassFromString(@"AFAddress"))
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
                        [object initPlaceholderWithPrimaryKey:primaryKey];
                        [self injectObject:object];
                        [objectsToSet addObject:[NSArray arrayWithObjects:object, objectDictionary, nil]];
                    }
                    if (object) [objects addObject:object];
                }
            }
            [className release];
        }
    }

    NSArray      *setPair;
    NSEnumerator *enumerator     = [objectsToSet objectEnumerator];
    while ((setPair = [enumerator nextObject]))
    {
        [(AFObject*) [setPair objectAtIndex:0] setContentFromDictionary:(NSDictionary *) [setPair objectAtIndex:1]];
    }
    [objectsToSet release];
    return objects;
}

- (void)saveObjectToDefaults:(NSObject <NSCoding> *)obj forKey:(NSString *)key
{
    NSAssert(key && [key isKindOfClass:[NSString class]] && [key length] > 0, @"Invalid key calling %@", NSStringFromSelector(_cmd));

    AFLog(@"Saving '%@' to defaults under key '%@'", obj, key);

    NSMutableData   *objectData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver   = [[NSKeyedArchiver alloc] initForWritingWithMutableData:objectData];
    [archiver setDelegate:self];
    [archiver encodeRootObject:obj];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:objectData forKey:key];
    [archiver release];
    [objectData release];

    [[NSUserDefaults standardUserDefaults] synchronize];
    AFLog(@"...AFRequestEventFinished saving key '%@'", key);
}

- (NSObject <NSCoding> *)loadObjectFromDefaultsForKey:(NSString *)key
{
    NSAssert(key && [key isKindOfClass:[NSString class]] && [key length] > 0, @"Invalid key calling %@", NSStringFromSelector(_cmd));

    AFLog(@"Loading key '%@' from defaults", key);

    NSData *objectData = [[NSUserDefaults standardUserDefaults] dataForKey:key];

    [AFUtil logData:objectData];

    if (objectData)
    {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:objectData];
        [unarchiver setDelegate:self];
        NSObject <NSCoding> *object = [unarchiver decodeObject];
        [unarchiver finishDecoding];
        [unarchiver release];

        AFLog(@"...AFRequestEventFinished loading '%@' from key '%@'", object, key);
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
    if (object && [object  isKindOfClass:[AFObject class]])
    {
        int primaryKey = [((AFObject*) object) primaryKey];
        if ([self containsObjectOfType:[object class] withPrimaryKey:primaryKey])
        {
            return [self objectOfType:[object class] withPrimaryKey:primaryKey];
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
