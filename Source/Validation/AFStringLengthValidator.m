#import "AFStringLengthValidator.h"

@implementation AFStringLengthValidator

- (id)initWithMode:(lengthValidationMode)modeIn length:(uint8_t)lengthIn
{
    if ((self = [super init]))
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
        case EXACTLY:
            return [(NSString *) testObject length] == length;
        case AT_LEAST:
            return [(NSString *) testObject length] >= length;
        case AT_MOST:
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
         case EXACTLY:  return [NSString stringWithFormat:@"be exactly %i characters long.",length];
         case AT_LEAST: return [NSString stringWithFormat:@"be at least %i characters long.",length];
         case AT_MOST:  return [NSString stringWithFormat:@"no more than %i characters long.",length];
         default: break;
     }
     return NO;
      */
}

@end
