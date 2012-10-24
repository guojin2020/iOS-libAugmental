//Download enumerations
typedef enum RequestState
{
    Idle        = 0,  // The request is Idle
    Pending     = 1,  // The request is due to be Fulfilled (queued, waiting initialising etc.)
    InProcess   = 2,  // The request is currently in the process of being Fulfilled.
    Fulfilled   = 3   // The request has been Fulfilled.
}
RequestState;
