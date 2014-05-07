//
// Created by augmental on 27/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "AFNetUtils.h"


@implementation AFNetUtils

+ (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len    = (__uint8_t) sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    // Recover reachability flags
    SCNetworkReachabilityRef   defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &zeroAddress);
    SCNetworkReachabilityFlags flags;

    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease((CFTypeRef)defaultRouteReachability);

    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }

    BOOL isReachable     = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi         = flags & kSCNetworkReachabilityFlagsTransientConnection;

    return ((isReachable && !needsConnection) || nonWiFi) ? YES : NO;
}

@end