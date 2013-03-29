#import "AFStringNotEmptyValidator.h"

static AFStringNotEmptyValidator *defaultCache = nil;

@implementation AFStringNotEmptyValidator

+ (NSObject <AFValidator> *)sharedInstance
{
    if (!defaultCache) defaultCache = [[AFStringNotEmptyValidator alloc] init];
    return defaultCache;
}

- (BOOL)isValid:(NSObject *)testObject
{return [((NSString *) testObject) length] > 0;}

- (NSString *)conditionDescription
{return @"not be empty.";}

@end
