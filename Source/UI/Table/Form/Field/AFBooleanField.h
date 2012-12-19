#import <Foundation/Foundation.h>
#import "AFField.h"
#import "AFField.h"

@protocol AFFieldPersistenceDelegate;

@interface AFBooleanField : AFField
{
    UISwitch *valueSwitch;
}

@end
