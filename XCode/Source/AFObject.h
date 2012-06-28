
#import "AFEventObserver.h"

@class AFSession;
@class AFEventManager;

/**
 This is one of the highest level protocols of the application, describing any data object retrieved from an integer-keyed
 database.
 
 A key characteristic of AFObjects is that they all have, and are uniquely identifiable by, a type (or modelName) and number (or primary key).
 An AFObjects content may be set by an NSDictionary of key/value pairs, whose format will be specific to the implementing class.
 */
@protocol AFObject <NSCoding>

/**
 Initialises a placeholder instance of the AFObject implementation.
 */
-(id)initPlaceholderWithPrimaryKey:(int)primaryKeyIn;
//-(id)initWithPrimaryKey:(int)primaryKeyIn;

/**
 This is where initialisation common to the init and initWithCoder paths should go.
 */
-(void)commonInit;

/**
 Probably the most fundamental method of any AFObject, setContentFromDictionary will be implemented
 to fill out all fields of the implementing class from an NSDictionary representation. The exact key/value representation
 may be entirely determined by the implementation to suit the type of data.
 */
-(void)setContentFromDictionary:(NSDictionary*)dictionary; //Set the content from a dictionary - used as callback

/**
 The primary key of the object: this must be unique and the same as given in any originating database table.
 */
-(int)primaryKey; //The primary key of this object as per the database

-(void)setPlaceholderValues;

/**
 Reflects whether this AFObject is in 'placeholder' state, this can be very useful when retrieving and displaying data from a remote server.
 UI components which display AFObject data can be constructed and painted on screen using a placeholder instance which gets
 called back to and update by a server request. Using this asynchronous method, rather than waiting for completion of data before
 screen-drawing, keeps the application feeling more responsive to the user.
 */
-(BOOL)isPlaceholder;

-(SEL)defaultComparisonSelector;

//-(NSString*)key;

/**
 The model name (or 'type') of this data object. 
 */
+(NSString*)modelName; //The JSON model name for this type of AFObject

@property (nonatomic, retain, readonly) AFEventManager* eventManager;
@property (nonatomic, readonly) BOOL isPlaceholder;
@property (nonatomic, readonly) int primaryKey;

@end
