//State enumerations
typedef enum AFSessionState
{
    AFSessionStateUnknown       = 1, //The Session object is not initialised or there has been an AFSessionStateError.
    AFSessionStateDisconnected  = 2, //Means the Session object is initalised, or has AFRequestEventFinished its last connection.
    AFSessionStateDisconnecting = 3, //The session object is in the process of AFSessionStateDisconnecting.
    AFSessionStateConnecting    = 4, //Means the login request has been sent, AFRequestStatePending response.
    AFSessionStateConnected     = 5, //Means the Session is authenticated and open for business (even if OFFLINE).
    AFSessionStateRejected      = 6, //Same as STATE_NOT_CONNECTED but the last comunication from the server was an authentication refusal.
    AFSessionStateError         = 7
}
AFSessionState;

/**
 Holding class for the login states of an AFSession, defined
 as a static enumeration.
 */
@interface AFSessionStates : NSObject
{}

/**
 Returns a string description of the specified state, for debug-logging purposes.
 */
+ (NSString *)stringForState:(AFSessionState)stateIn;

@end

