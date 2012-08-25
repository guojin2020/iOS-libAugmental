#import "AFValidatableValidator.h"
#import "AFValidatable.h"

static AFValidatableValidator *sharedInstance = nil;

@implementation AFValidatableValidator

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!sharedInstance) sharedInstance = [[AFValidatableValidator alloc] init];
    return sharedInstance;
}

- (BOOL)isValid:(NSObject *)testObject
{
    return [testObject conformsToProtocol:@protocol(AFValidatable)] && [(NSObject <AFValidatable> *) testObject valid];
}

- (NSString *)conditionDescription
{return @"be valid.";}

@end
