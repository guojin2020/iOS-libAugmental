#import <Foundation/Foundation.h>

#import "AFValidatable.h"
#import "AFObservable.h"

extern SEL
    AFEventObjectFieldUpdated,
    AFEventObjectInvalidated,
    AFEventObjectValidated;

@class AFSession;
@class AFObjectRequest;
@protocol AFRequestEndpoint;

/**
 AFObject provides state and functionality which will be common to all AFObject implementations.
 It is essentially abstract and intended to be subclassed: it should never be instantiated directly.
 **/
/* DEPRECATED_ATTRIBUTE */
@interface AFObject : AFObservable <NSCoding, AFValidatable>
{


    //The objects primary key; this will match the primary key of this objects database representation on the server.
    int  primaryKey;
    //BOOL isValid;
    BOOL isPlaceholder;

    /**
     The batchUpdating flag is used to temporarily suppress state-change broadcasts to this AFObjects observers.
     A prime example of where this functionality is needed, is where multiple changes are being made to the objects fields,
     and there is an observer which updates a UI showing those fields. To have the the observer informed, and the UI updated,
     after every change in sequence would be a wasteful use of CPU and display resources.
     **/
    BOOL batchUpdating;

    BOOL updateNeeded;
}
/**
 Initialises a placeholder instance of the AFObject implementation.
 */
- (id)initPlaceholderWithPrimaryKey:(int)primaryKeyIn;
//-(id)initWithPrimaryKey:(int)primaryKeyIn;

/**
 This is where initialisation common to the init and initWithCoder paths should go.
 */
- (void)commonInit;

/**
 Probably the most fundamental method of any AFObject, setContentFromDictionary will be implemented
 to fill out all fields of the implementing class from an NSDictionary representation. The exact key/value representation
 may be entirely determined by the implementation to suit the type of data.
 */
- (void)setContentFromDictionary:(NSDictionary *)dictionary; //Set the content from a array - used as callback

/**
 The primary key of the object: this must be unique and the same as given in any originating database table.
 */
- (int)primaryKey; //The primary key of this object as per the database

- (void)setPlaceholderValues;

/**
 Reflects whether this AFObject is in 'placeholder' state, this can be very useful when retrieving and displaying data from a remote server.
 UI components which display AFObject data can be constructed and painted on screen using a placeholder instance which gets
 called back to and update by a server request. Using this asynchronous method, rather than waiting for completion of data before
 screen-drawing, keeps the application feeling more responsive to the USER.
 */
- (BOOL)isPlaceholder;

//- (SEL)defaultComparisonSelector;

/**
 The model name (or 'type') of this data object.
 */
+ (NSString *)modelName; //The JSON model name for this type of AFObject

@property(nonatomic, readonly) BOOL isPlaceholder;
@property(nonatomic, readonly) int  primaryKey;

/**
 <p>All AFObjects inherit a simple 'batch updating' mechanism. Under normal conditions, calls to fieldUpdated are immediately
 reported to this objects observers, via the eventManager, as an AFEventObjectFieldUpdated AFEvent.</p>
 <p>In the example case of an observer which updates a UI showing this objects fields,
 having the the observer informed after every change in sequence would result in multiple screenupdates and a wasteful use of
 CPU and display resources.</p>
 <p>startBatchUpdate allows AFEventObjectFieldUpdated AFEvent firing to be suppressed. </p>
 **/
- (void)startBatchUpdate;

/**
 See the documentation for startBatchUpdate which explains use of an AFObjects 'batch updating' mechanism.
 **/
- (void)finishBatchUpdating;

/**
 
 **/
- (void)fieldUpdated;


/**
 This method should set appropriate placeholder values for all the fields in this AFObject.
 **/

- (NSString *)placeholderString;

- (NSNumber *)placeholderNumber;

- (NSDate *)placeholderDate;

- (void)wasValidated;

- (void)wasInvalidated;

+ (NSString *)placeholderString;

+ (NSNumber *)placeholderNumber;

+ (NSDate *)placeholderDate;

- (SEL)defaultComparisonSelector;

/**
 Convenience method to delete this object from the server and local caches, using the current shared AFSession.
 Equivalent to calling: [[AFSession sharedSession].cacheImage deleteObject:self endpoint:endpoint];
 */
- (AFObjectRequest *)deleteWithEndpoint:(NSObject <AFRequestEndpoint> *)endpoint;

@end
