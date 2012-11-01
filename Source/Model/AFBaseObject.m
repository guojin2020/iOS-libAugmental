#import "AFBaseObject.h"
#import "AFEventManager.h"

@implementation AFBaseObject

static NSString *placeholderString = nil;
static NSNumber *placeholderNumber = nil;
static NSDate   *placeholderDate   = nil;

static NSString *PRIMARY_KEY_KEY    = @"primaryKey";
static NSString *IS_PLACEHOLDER_KEY = @"isPlaceholder";
static NSString *BATCH_UPDATING_KEY = @"batchUpdating";
static NSString *UPDATE_NEEDED_KEY  = @"updateNeeded";

+ (void)initialize
{
    if (!placeholderString) placeholderString = @"Loading...";
    if (!placeholderNumber) placeholderNumber = [[NSNumber alloc] initWithInt:0];
    if (!placeholderDate) placeholderDate     = [[NSDate alloc] init];
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
        //valid = NO;
        isPlaceholder = YES;
    }
    return self;
}

- (void)commonInit
{
    eventManager  = [[AFEventManager alloc] init];
    batchUpdating = NO;
    updateNeeded  = NO;
}

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
    if (batchUpdating && updateNeeded) [eventManager broadcastEvent:(AFEvent) AFEventObjectFieldUpdated source:self];
    batchUpdating = NO;
    updateNeeded  = NO;
}

- (void)fieldUpdated
{
    if (batchUpdating) updateNeeded = YES;
    else [eventManager broadcastEvent:(AFEvent) AFEventObjectFieldUpdated source:self];
}

- (void)setContentFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary)[self wasInvalidated];
    else
    {
        isPlaceholder = NO;

        NSAssert([((NSNumber *) [dictionary objectForKey:@"pk"]) intValue] == primaryKey, @"Whoah! What's happening, tried to set information for this object using a dictionary with an unmatched primary key, are you crazy!?");

        //primaryKey = [((NSNumber*)[dictionary objectForKey:@"pk"]) intValue];
    }
}

- (SEL)defaultComparisonSelector
{return nil;}

- (NSString *)placeholderString
{return placeholderString;}

- (NSNumber *)placeholderNumber
{return placeholderNumber;}

- (NSDate *)placeholderDate
{return placeholderDate;}

- (void)setPlaceholderValues
{[self doesNotRecognizeSelector:_cmd];}

- (BOOL)valid
{
    return primaryKey > 0 && !isPlaceholder;
}

- (void)wasValidated
{
    isPlaceholder = NO;
    [eventManager broadcastEvent:(AFEvent) AFEventObjectValidated source:self];
}

- (void)wasInvalidated
{
    isPlaceholder = YES;
    [eventManager broadcastEvent:(AFEvent) AFEventObjectInvalidated source:self];
}

- (AFObjectRequest *)deleteWithEndpoint:(NSObject <AFRequestEndpoint> *)endpoint
{
    return nil;

    //return [[AFSession sharedSession].cache deleteObject:(NSObject<AFObject>*)self endpoint:endpoint];
}

- (int)primaryKey
{return primaryKey;}

- (BOOL)isPlaceholder
{return isPlaceholder;}

+ (NSString *)modelName
{return nil;}

+ (NSString *)placeholderString
{return placeholderString;}

+ (NSNumber *)placeholderNumber
{return placeholderNumber;}

+ (NSDate *)placeholderDate
{return placeholderDate;}

//==================================>> NSCoding

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInt:primaryKey forKey:PRIMARY_KEY_KEY];
    [coder encodeBool:isPlaceholder forKey:IS_PLACEHOLDER_KEY];
    [coder encodeBool:batchUpdating forKey:BATCH_UPDATING_KEY];
    [coder encodeBool:updateNeeded forKey:UPDATE_NEEDED_KEY];
}

//====================== NSCodin

- (void)dealloc
{
    [eventManager release];
    [super dealloc];
}

@synthesize eventManager;

@end
