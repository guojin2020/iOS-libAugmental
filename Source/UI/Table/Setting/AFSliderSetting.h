#import <Foundation/Foundation.h>
#import "AFBaseSetting.h"
#import "AFSetting.h"

@protocol AFSettingPersistenceDelegate;

@interface AFSliderSetting : AFBaseSetting <AFSetting>
{
    UISlider *slider;
    float minimum;
    float maximum;
}

- (id)initWithIdentity:(NSString *)identityIn
               minimum:(float)minimumIn
               maximum:(float)maximumIn;
@end
