//Download enumerations
typedef enum requestState
{
    pending   = 1,        //The Session object is not initialised or there has been an error.
    inProcess = 2,    //Means the Session object is initalised, or has finished its last connection.
    fulfilled = 3    //The session object is in the process of disconnecting.
}
        requestState;
