#import "AFSessionStates.h"

@implementation AFSessionStates

+ (NSString *)stringForState:(AFSessionState)stateIn
{
    if (stateIn == (AFSessionState) AFSessionStateDisconnected) return @"Disconnected";
    else if (stateIn == (AFSessionState) AFSessionStateConnecting) return @"Connecting";
    else if (stateIn == (AFSessionState) AFSessionStateConnected) return @"Connected";
    else if (stateIn == (AFSessionState) AFSessionStateDisconnecting) return @"Disconnecting";
    else if (stateIn == (AFSessionState) AFSessionStateRejected) return @"Rejected";
    else return @"Unknown";
}

@end
