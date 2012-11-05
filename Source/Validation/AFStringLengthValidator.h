#import <Foundation/Foundation.h>
#import "AFValidator.h"

typedef enum AFLengthValidation
{
    AFLengthValidationExact   = 1,
    AFLengthValidationMinimum = 2,
    AFLengthValidationMaximum = 3
}
AFLengthValidation;

@interface AFStringLengthValidator : NSObject <AFValidator>
{
    AFLengthValidation mode;
    uint8_t              length;
}

- (id)initWithMode:(AFLengthValidation)modeIn length:(uint8_t)lengthIn;

@end
