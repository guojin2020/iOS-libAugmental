
//Download enumerations
typedef enum AFRequestState
{
    AFRequestStateIdle      = 0,  // The request is AFRequestStateIdle
    AFRequestStatePending   = 1,  // The request is due to be AFRequestStateFulfilled (AFRequestEventQueued, waiting initialising etc.)
    AFRequestStateInProcess = 2,  // The request is currently in the process of being AFRequestStateFulfilled.
    AFRequestStateFulfilled = 3,  // The request has been AFRequestStateFulfilled.
    AFRequestStateFailed    = 4   // The request has been AFRequestStateFulfilled.
}
AFRequestState;
