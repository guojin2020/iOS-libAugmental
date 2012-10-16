#import "AFUtil.h"

#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h> 

#import "AFObject.h"

@implementation AFUtil

static const NSNumberFormatter *priceFormatter;
static const NSNumberFormatter *weightFormatter;

+ (void)initialize
{
    priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [priceFormatter setPositiveFormat:@"##0.00"];

    weightFormatter = [[NSNumberFormatter alloc] init];
    [weightFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [weightFormatter setPositiveFormat:@"##0.0"];
}

static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};


+ (void)dumpDictionary:(NSDictionary *)dictionary
{
    for (id key in dictionary)
    {
    }
}

+ (NSString *)priceStringFromFloat:(float)priceFloat
{
    return priceFloat < 0 ? @"£--.--" : priceFloat == 0 ? @"FREE" : [NSString stringWithFormat:@"£%@", [priceFormatter stringFromNumber:[NSNumber numberWithFloat:priceFloat]]];
}

+ (NSString *)weightStringFromFloat:(float)weightFloat
{
    return [NSString stringWithFormat:@"%@Kg", [weightFormatter stringFromNumber:[NSNumber numberWithFloat:weightFloat]]];
}

+ (void)logViewSize:(UIView *)view withName:(NSString *)name
{
}

+ (BOOL)is32OrLater
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2;

    /*
     NSString* versionString = [[[UIDevice currentDevice] systemVersion] substringToIndex:3];
     NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
     NSNumber* versionNumber = [numberFormatter numberFromString:versionString];
     [numberFormatter release];
     BOOL isLater = [versionNumber floatValue]>=3.2;
     return isLater;
      */
}

+ (void)displayInfoWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+ (NSArray *)allocIdArrayFromCsv:(NSString *)csvIdList
{
    NSNumberFormatter *formatter        = [[NSNumberFormatter alloc] init];
    NSArray           *stringComponents = [csvIdList componentsSeparatedByString:@","];
    NSMutableArray    *numberComponents = [[NSMutableArray alloc] initWithCapacity:[stringComponents count]];
    NSNumber          *idNumber;
    for (NSString     *idString in stringComponents)
    {
        idNumber = [formatter numberFromString:idString];
        if (idNumber)[numberComponents addObject:idNumber];
        else
        {
            [numberComponents release];
            numberComponents = nil;
            break;
        }
    }
    [formatter release];
    return numberComponents;
}

+ (NSString *)allocCsvIdListFromObjectArray:(NSArray *)objects
{
    NSMutableString *objectsIdCsv = [[NSMutableString alloc] init];
    @synchronized (objects)
    {
        int objectsCount = [objects count];
        if (objectsCount > 0 && [[objects objectAtIndex:0] conformsToProtocol:@protocol(AFObject)])
        {
            [objectsIdCsv appendFormat:@"%i", ((NSObject <AFObject> *) [objects objectAtIndex:0]).primaryKey];
            for (int i = 1; i < objectsCount; i++)
            {
                if ([[objects objectAtIndex:(NSUInteger) i] conformsToProtocol:@protocol(AFObject)])
                {
                    [objectsIdCsv appendFormat:@",%i", ((NSObject <AFObject> *) [objects objectAtIndex:(NSUInteger) i]).primaryKey];
                }
                else
                {
                    [objectsIdCsv release];
                    objectsIdCsv = nil;
                    break;
                }
            }
        }
    }
    return objectsIdCsv;
}

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

+ (void)logData:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", string);
    [string release];
}

+ (NSString *)newDurationString:(NSTimeInterval)time
{
    int days    = (int) floor(time / 86400);
    int hours   = (int) floor((time / 3600) - (days * 24));
    int minutes = (int) floor((time / 60) - (days * 1440) - (hours * 60));
    //int seconds = (int)time % 60;

    if (days == 0)
    {
        if (hours == 0)
        {
            if (minutes == 0) return [[NSString alloc] initWithString:@"Less than a minute"];
            else return [[NSString alloc] initWithFormat:@"newNextBarButtonItemForPageimately %i minute%@", minutes, minutes == 1 ? @"" : @"s"];
        }
        else return [[NSString alloc] initWithFormat:@"%i hour%@, %i minute%@", hours, hours == 1 ? @"" : @"s", minutes, minutes == 1 ? @"" : @"s"];
    }
    else return [[NSString alloc] initWithFormat:@"%i day%@, %i hour%@, %i minute%@", days, days == 1 ? @"" : @"s", hours, hours == 1 ? @"" : @"s", minutes, minutes == 1 ? @"" : @"s"];

    /*
     if(days==0 && hours==0 && minutes==0) return @"Less than a minute";
     if(days==0 && hours==0) return

     NSMutableString* string = [[NSMutableString alloc] initWithCapacity:64];
     if(days>0)[string appendFormat:@"%i days, ",days];
     if(hours>0)[string appendFormat:@"%i hours, ",hours];
     if(minutes>0)[string appendFormat:@"%i minutes, ",minutes];
     //if(seconds>0)[string appendFormat:@"%i seconds",seconds];

     return string;
      */
}

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length
{
    int lentext = [data length];
    if (lentext < 1) return @"";

    char *outbuf = malloc((size_t) (lentext * 4 / 3 + 4)); // add 4 to be sure

    if (!outbuf) return nil;

    const unsigned char *raw = [data bytes];

    int inp    = 0;
    int outp   = 0;
    int do_now = lentext - (lentext % 3);

    for (outp = 0, inp = 0; inp < do_now; inp += 3)
    {
        outbuf[outp++] = base64EncodingTable[(raw[inp] & 0xFC) >> 2];
        outbuf[outp++] = base64EncodingTable[((raw[inp] & 0x03) << 4) | ((raw[inp + 1] & 0xF0) >> 4)];
        outbuf[outp++] = base64EncodingTable[((raw[inp + 1] & 0x0F) << 2) | ((raw[inp + 2] & 0xC0) >> 6)];
        outbuf[outp++] = base64EncodingTable[raw[inp + 2] & 0x3F];
    }

    if (do_now < lentext)
    {
        unsigned char tmpbuf[2] = {0, 0};
        int           left      = lentext % 3;
        for (int      i         = 0; i < left; i++)
        {
            tmpbuf[i] = raw[do_now + i];
        }
        raw = tmpbuf;
        inp = 0;
        outbuf[outp++]                = base64EncodingTable[(raw[inp] & 0xFC) >> 2];
        outbuf[outp++]                = base64EncodingTable[((raw[inp] & 0x03) << 4) | ((raw[inp + 1] & 0xF0) >> 4)];
        if (left == 2) outbuf[outp++] = base64EncodingTable[((raw[inp + 1] & 0x0F) << 2) | ((raw[inp + 2] & 0xC0) >> 6)];
        else outbuf[outp++] = '=';
        outbuf[outp++]      = '=';

    }

    NSString *ret = [[[NSString alloc] initWithBytes:outbuf length:(NSUInteger) outp encoding:NSASCIIStringEncoding] autorelease];
    free(outbuf);

    return ret;
}

+ (BOOL)isIPad
{
#ifdef UI_USER_INTERFACE_IDIOM
    return UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad;
#else
		return NO;
	#endif
}

@end
