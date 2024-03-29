
#import "AFSessionState.h"

@class AFSession;

/* DEPRECATED_ATTRIBUTE */
@protocol AFSessionObserver

@optional
- (void)stateOfSession:(AFSession *)changedSession changedFrom:(AFSessionState)oldState to:(AFSessionState)newState;

- (void)session:(AFSession *)changedSession becameOffline:(BOOL)offlineState;
//-(void)customerChangedFrom:(AFCustomer*)oldCustomer to:(AFCustomer*)newCustomer;

@end
