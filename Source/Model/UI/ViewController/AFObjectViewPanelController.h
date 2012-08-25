#import "AFObject_PanelViewable.h"

@class AFSession;


@protocol AFObjectViewPanelController

- (id)initWithObject:(NSObject <AFObject_PanelViewable> *)objectIn nibName:(NSString *)nibNameIn;

- (id)initWithObject:(NSObject <AFObject_PanelViewable> *)objectIn;

/**
 * This is called by when one or more data fields in this object have been updated, as 
 */
- (void)objectFieldUpdatedInternal;

- (void)validated;

- (void)invalidated;

@property(nonatomic, readonly) NSObject <AFObject_PanelViewable> *object;

@end
