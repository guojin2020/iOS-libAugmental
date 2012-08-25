#import "AFEMailAddressValidator.h"
//#import "GTMRegex.h"

@implementation AFEMailAddressValidator

static NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//static GTMRegex *regex = nil;

static AFEMailAddressValidator *sharedInstance = nil;

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!sharedInstance) sharedInstance = [[AFEMailAddressValidator alloc] init];
    return sharedInstance;
}

- (BOOL)isValid:(NSObject *)testObject
{
    return false; //FIX!!!

    //if(!regex) regex = [[GTMRegex regexWithPattern:emailRegEx] retain];
    //return [regex matchesString:(NSString*)testObject];
}

- (NSString *)conditionDescription
{return @"be a valid eMail address.";}

@end
