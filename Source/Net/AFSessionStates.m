#import "AFSessionStates.h"

@implementation AFSessionStates

+ (NSString *)stringForState:(sessionState)stateIn
{
    if (stateIn == (sessionState) disconnected) return @"Disconnected";
    else if (stateIn == (sessionState) connecting) return @"Connecting";
    else if (stateIn == (sessionState) connected) return @"Connected";
    else if (stateIn == (sessionState) disconnecting) return @"Disconnecting";
    else if (stateIn == (sessionState) rejected) return @"Rejected";
    else return @"Unknown";
}

@end
