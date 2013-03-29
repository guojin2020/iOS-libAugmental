#import "AFValidatableValidator.h"
#import "AFValidatable.h"

static AFValidatableValidator *defaultCache = nil;

@implementation AFValidatableValidator

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!defaultCache) defaultCache = [[AFValidatableValidator alloc] init];
    return defaultCache;
}

- (BOOL)isValid:(NSObject *)testObject
{
    return [testObject conformsToProtocol:@protocol(AFValidatable)] && [(NSObject <AFValidatable> *) testObject valid];
}

- (NSString *)conditionDescription
{return @"be valid.";}

@end
