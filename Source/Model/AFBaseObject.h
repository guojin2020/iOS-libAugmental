#import <Foundation/Foundation.h>
#import "AFObject.h"
#import "AFEventObserver.h"

#import "AFValidatable.h"
#import "AFRequestEndpoint.h"


@class AFSession;
@class AFObjectRequest;

/**
 AFBaseObject provides state and functionality which will be common to all AFObject implementations.
 It is essentially abstract and intended to be subclassed: it should never be instantiated directly.
 **/
@interface AFBaseObject : NSObject <AFObject, NSCoding, AFValidatable>
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

    /**
      Each AFObject has its own eventManager instance which manages observers and broadcasts relevant object events to them.
      **/
    AFEventManager *eventManager;
}

- (id)initPlaceholderWithPrimaryKey:(int)primaryKeyIn;

- (void)commonInit;

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

- (void)setContentFromDictionary:(NSDictionary *)dictionary;

/**
 This method should set appropriate placeholder values for all the fields in this AFObject.
 **/
- (void)setPlaceholderValues;

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
 Equivalent to calling: [[AFSession sharedSession].cache deleteObject:self endpoint:endpoint];
 */
- (AFObjectRequest *)deleteWithEndpoint:(NSObject <AFRequestEndpoint> *)endpoint;


//@property (nonatomic) BOOL valid;

@end
