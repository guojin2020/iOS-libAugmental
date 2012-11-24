#import <Foundation/Foundation.h>
#import "AFValidator.h"

@class AFPasswordField;

@interface AFPasswordValidator : NSObject <AFValidator>
{
    AFPasswordField *comparisonSetting;
    BOOL allowEmpty;
}

- (id)initWithComparisonSetting:(AFPasswordField *)comparisonSettingIn allowsEmpty:(BOOL)allowEmptyIn;

@property(nonatomic, retain) AFPasswordField *comparisonSetting;

@end
