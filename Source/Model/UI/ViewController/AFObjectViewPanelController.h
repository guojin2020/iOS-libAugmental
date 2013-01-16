#import "AFPanelViewableObject.h"

@class AFSession;


@protocol AFObjectViewPanelController

- (id)initWithObject:(NSObject <AFPanelViewableObject> *)objectIn nibName:(NSString *)nibNameIn;

- (id)initWithObject:(NSObject <AFPanelViewableObject> *)objectIn;

/**
 * This is called by when one or more data fields in this object have been updated, as 
 */
- (void)objectFieldUpdated:(AFObject *)objectIn;
- (void)objectValidated:(AFObject *)objectIn;
- (void)objectInvalidated:(AFObject *)objectIn;

@property(nonatomic, readonly) NSObject <AFPanelViewableObject> *object;

@end
