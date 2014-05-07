
#import "AFPrice.h"

@implementation AFPrice

- (id)initWithPrice:(NSNumber *)priceIn priceLocale:(NSLocale *)priceLocaleIn
{
    self = [super init];
    if (self)
    {
        self.price = priceIn;
        self.priceLocale = priceLocaleIn;
    }
    return self;
}

- (NSString *)string
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *string = [numberFormatter stringFromNumber:self.price];
    return string;
}

@end