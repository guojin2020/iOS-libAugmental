#import "AFStringLengthValidator.h"

@implementation AFStringLengthValidator

- (id)initWithMode:(AFLengthValidation)modeIn length:(uint8_t)lengthIn
{
    if ((self = [self init]))
    {
        mode   = modeIn;
        length = lengthIn;
    }
    return self;
}

- (BOOL)isValid:(NSObject *)testObject
{
    switch (mode)
    {
        case AFLengthValidationExact:
            return [(NSString *) testObject length] == length;
        case AFLengthValidationMinimum:
            return [(NSString *) testObject length] >= length;
        case AFLengthValidationMaximum:
            return [(NSString *) testObject length] <= length;
        default:
            break;
    }
    return NO;
}

- (NSString *)conditionDescription
{
    return @"";
    /*
     switch(mode)
     {
         case AFLengthValidationExact:  return [NSString stringWithFormat:@"be exactly %i characters long.",length];
         case AFLengthValidationMinimum: return [NSString stringWithFormat:@"be at least %i characters long.",length];
         case AFLengthValidationMaximum:  return [NSString stringWithFormat:@"no more than %i characters long.",length];
         default: break;
     }
     return NO;
      */
}

@end
