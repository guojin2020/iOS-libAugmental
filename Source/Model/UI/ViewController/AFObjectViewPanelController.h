#import "AFPanelViewableObject.h"

@class AFSession;


@protocol AFObjectViewPanelController

- (id)initWithObject:(NSObject <AFPanelViewableObject> *)objectIn nibName:(NSString *)nibNameIn;

- (id)initWithObject:(NSObject <AFPanelViewableObject> *)objectIn;

/**
 * This is called by when one or more data fields in this object have been updated, as 
 */
- (void)objectFieldUpdatedInternal;

- (void)validated;

- (void)invalidated;

@property(nonatomic, readonly) NSObject <AFPanelViewableObject> *object;

@end
