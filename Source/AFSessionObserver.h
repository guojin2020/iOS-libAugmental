
#import "AFSessionStates.h"
#import "AFSessionObserver.h"

@class AFSession;
//@class AFCustomer;

@protocol AFSessionObserver

@optional
-(void)stateOfSession:(AFSession*)changedSession changedFrom:(sessionState)oldState to:(sessionState)newState;
-(void)session:(AFSession*)changedSession becameOffline:(BOOL)offlineState;
//-(void)customerChangedFrom:(AFCustomer*)oldCustomer to:(AFCustomer*)newCustomer;

@end
