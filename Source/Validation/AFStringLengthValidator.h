#import <Foundation/Foundation.h>
#import "AFValidator.h"

typedef enum lengthValidationMode
{
    EXACTLY = 1, AT_LEAST = 2, AT_MOST = 3
} lengthValidationMode;

@interface AFStringLengthValidator : NSObject <AFValidator>
{
    lengthValidationMode mode;
    uint8_t              length;
}

- (id)initWithMode:(lengthValidationMode)modeIn length:(uint8_t)lengthIn;

@end
