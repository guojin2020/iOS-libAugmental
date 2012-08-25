#import "AFPasswordValidator.h"
//#import "GTMRegex.h"
#import "AFPasswordSetting.h"

static NSObject <AFValidator> *sharedInstance = nil;

@implementation AFPasswordValidator

static NSString *passwordRegEx = @"[A-Za-z0-9]{8,16}";
//static GTMRegex *regex = nil;

- (id)initWithComparisonSetting:(AFPasswordSetting *)comparisonSettingIn allowsEmpty:(BOOL)allowEmptyIn
{
    if ((self = [super init]))
    {
        comparisonSetting = [comparisonSettingIn retain];
        allowEmpty        = allowEmptyIn;
    }
    return self;
}

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!sharedInstance) sharedInstance = [[AFPasswordValidator alloc] init];
    return sharedInstance;
}

- (BOOL)isValid:(NSObject *)testObject
{
    return NO; //Fix!!

    /*
   if(!regex) regex = [[GTMRegex regexWithPattern:passwordRegEx] retain];
   return ((allowEmpty&&([(NSString*)testObject length]==0)) || [regex matchesString:(NSString*)testObject]) && (!comparisonSetting || [((NSString*)(comparisonSetting.value)) isEqualToString:(NSString*)testObject]);
    */
}

- (NSString *)conditionDescription
{return @"contain only numbers and letters, and be 8-16 characters long.";}

- (void)dealloc
{
    [comparisonSetting release];
    [super dealloc];
}

@synthesize comparisonSetting;

@end
