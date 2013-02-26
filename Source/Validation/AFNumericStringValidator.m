#import "AFNumericStringValidator.h"
//#import "GTMRegex.h"

@implementation AFNumericStringValidator

static AFNumericStringValidator *sharedInstance = nil;

//static NSString *emailRegEx = @"[0-9]+";
//static GTMRegex *regex = nil;

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!sharedInstance) sharedInstance = [[AFNumericStringValidator alloc] init];
    return sharedInstance;
}

- (BOOL)isValid:(NSObject *)testObject
{
    return false; //FIX!!!

    //if(!regex) regex = [[GTMRegex regexWithPattern:emailRegEx] retain];
    //return [regex matchesString:(NSString*)testObject];
}

- (NSString *)conditionDescription
{return @"contain only numbers.";}

@end
