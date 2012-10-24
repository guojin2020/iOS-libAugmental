//State enumerations
typedef enum sessionState
{
    unknown       = 1,        //The Session object is not initialised or there has been an error.
    disconnected  = 2,    //Means the Session object is initalised, or has finished its last connection.
    disconnecting = 3,    //The session object is in the process of disconnecting.
    connecting    = 4,        //Means the login request has been sent, Pending response.
    connected     = 5,        //Means the Session is authenticated and open for business (even if OFFLINE).
    rejected      = 6,        //Same as STATE_NOT_CONNECTED but the last comunication from the server was an authentication refusal.
    error         = 7
}
        sessionState;

/**
 Holding class for the login states of an AFSession, defined
 as a static enumeration.
 */
@interface AFSessionStates : NSObject
{}

/**
 Returns a string description of the specified state, for debug-logging purposes.
 */
+ (NSString *)stringForState:(sessionState)stateIn;

@end

