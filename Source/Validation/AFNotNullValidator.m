#import "AFNotNullValidator.h"

static AFNotNullValidator *defaultCache = nil;

@implementation AFNotNullValidator

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!defaultCache) defaultCache = [[AFNotNullValidator alloc] init];
    return defaultCache;
}

- (BOOL)isValid:(NSObject *)testObject
{return testObject != nil;}

- (NSString *)conditionDescription
{return @"be set.";}

@end
