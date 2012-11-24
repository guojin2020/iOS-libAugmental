#import <Foundation/Foundation.h>
#import "AFBaseField.h"
#import "AFField.h"

@protocol AFFieldPersistenceDelegate;

@interface AFBooleanField : AFBaseField <AFField>
{
    UISwitch *valueSwitch;
}

@end
