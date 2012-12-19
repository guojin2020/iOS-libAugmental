
#import "AFObservable.h"
#import "AFObject.h"
#import "AFRequestEndpoint.h"

SEL
    AFEventObjectFieldUpdated,
    AFEventObjectInvalidated,
    AFEventObjectValidated,
    AFEventObjectDeallocating;

@implementation AFObject

static NSString *placeholderString = nil;
static NSNumber *placeholderNumber = nil;
static NSDate   *placeholderDate   = nil;

static NSString
        *PRIMARY_KEY_KEY    = @"primaryKey",
        *IS_PLACEHOLDER_KEY = @"isPlaceholder",
        *BATCH_UPDATING_KEY = @"batchUpdating",
        *UPDATE_NEEDED_KEY  = @"updateNeeded";

+ (void)initialize
{
    if (!placeholderString) placeholderString = @"Loading...";
    if (!placeholderNumber) placeholderNumber = [[NSNumber alloc] initWithInt:0];
    if (!placeholderDate)   placeholderDate   = [[NSDate alloc] init];

    AFEventObjectFieldUpdated   = @selector(objectFieldUpdated:), //Params: AFObject
    AFEventObjectInvalidated    = @selector(objectInvalidated:),  //Params: AFObject
    AFEventObjectValidated      = @selector(objectValidated:),    //Params: AFObject
    AFEventObjectDeallocating   = @selector(objectDeallocating:);
}

- (id)initPlaceholderWithPrimaryKey:(int)primaryKeyIn
{
    if ((self = [self init]))
    {
        primaryKey = primaryKeyIn;
        [self setPlaceholderValues];
    }
    return self;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self commonInit];
        isPlaceholder = NO;
    }
    return self;
}

- (void)commonInit
{
    eventManager  = [[AFObservable alloc] init];
    batchUpdating = NO;
    updateNeeded  = NO;
}

-(AFObservable *)eventManager { return eventManager; }

- (id)initWithCoder:(NSCoder *)coder;
{
    if ((self = [super init]))
    {
        [self commonInit];

        primaryKey    = [coder decodeIntForKey:PRIMARY_KEY_KEY];
        isPlaceholder = [coder decodeBoolForKey:IS_PLACEHOLDER_KEY];
        batchUpdating = [coder decodeBoolForKey:BATCH_UPDATING_KEY];
        updateNeeded  = [coder decodeBoolForKey:UPDATE_NEEDED_KEY];
    }
    return self;
}

- (void)startBatchUpdate
{
    batchUpdating = YES;
    updateNeeded  = NO;
}

- (void)finishBatchUpdating
{
    if (batchUpdating && updateNeeded) [eventManager notifyObservers:AFEventObjectFieldUpdated parameters:self];
    batchUpdating = NO;
    updateNeeded  = NO;
}

- (void)fieldUpdated
{
    if (batchUpdating) updateNeeded = YES;
    else
    {
        [self notifyObservers:AFEventObjectFieldUpdated parameters:self];
    }
}

- (void)setContentFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary)[self wasInvalidated];
    else
    {
        isPlaceholder = NO;
        NSAssert([((NSNumber *) [dictionary objectForKey:@"pk"]) intValue] == primaryKey, @"Internal inconsistency: AFObject being set using data with an unmatched primary key");
    }
}

- (SEL)         defaultComparisonSelector   { return nil; }
- (NSString *)  placeholderString           { return placeholderString; }
- (NSNumber *)  placeholderNumber           { return placeholderNumber; }
- (NSDate *)    placeholderDate             { return placeholderDate; }

- (void)setPlaceholderValues
{
    isPlaceholder = YES;
}

- (BOOL)valid
{
    return primaryKey > 0 && !isPlaceholder;
}

- (void)wasValidated
{
    isPlaceholder = NO;
    [self notifyObservers:AFEventObjectValidated parameters:self];
}

- (void)wasInvalidated
{
    isPlaceholder = YES;
    [self notifyObservers:AFEventObjectInvalidated parameters:self];
}

- (AFObjectRequest *)deleteWithEndpoint:(NSObject <AFRequestEndpoint> *)endpoint
{
    return nil;

    //return [[AFSession sharedSession].cacheImage deleteObject:(NSObject*)self endpoint:endpoint];
}

- (int)primaryKey {return primaryKey;}

- (BOOL)isPlaceholder {return isPlaceholder;}

+ (NSString *)modelName {return nil;}

+ (NSString *)placeholderString {return placeholderString;}

+ (NSNumber *)placeholderNumber {return placeholderNumber;}

+ (NSDate *)placeholderDate {return placeholderDate;}

//==================================>> NSCoding

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInt:primaryKey forKey:PRIMARY_KEY_KEY];
    [coder encodeBool:isPlaceholder forKey:IS_PLACEHOLDER_KEY];
    [coder encodeBool:batchUpdating forKey:BATCH_UPDATING_KEY];
    [coder encodeBool:updateNeeded forKey:UPDATE_NEEDED_KEY];
}

//====================== NSCoding

- (void)dealloc
{
    [eventManager release];
    [super dealloc];
}

@end
