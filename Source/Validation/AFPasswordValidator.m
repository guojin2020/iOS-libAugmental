#import "AFPasswordValidator.h"
#import "AFPasswordField.h"

static NSObject <AFValidator> *defaultCache = nil;

@implementation AFPasswordValidator

//static NSString *passwordRegEx = @"[A-Za-z0-9]{8,16}";
//static GTMRegex *regex = nil;

- (id)initWithComparisonSetting:(AFPasswordField *)comparisonSettingIn allowsEmpty:(BOOL)allowEmptyIn
{
    if ((self = [self init]))
    {
        comparisonSetting = comparisonSettingIn;
        allowEmpty        = allowEmptyIn;
    }
    return self;
}

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!defaultCache) defaultCache = [[AFPasswordValidator alloc] init];
    return defaultCache;
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


@synthesize comparisonSetting;

@end
