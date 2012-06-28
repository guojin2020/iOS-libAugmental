
#import <Foundation/Foundation.h>
#import "AFValidator.h"

@class AFPasswordSetting;

@interface AFPasswordValidator : NSObject <AFValidator>
{
	AFPasswordSetting* comparisonSetting;
	BOOL allowEmpty;
}

-(id)initWithComparisonSetting:(AFPasswordSetting*)comparisonSettingIn allowsEmpty:(BOOL)allowEmptyIn;

@property (nonatomic,retain) AFPasswordSetting* comparisonSetting;

@end
