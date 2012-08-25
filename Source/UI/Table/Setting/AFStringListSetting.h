#import <Foundation/Foundation.h>
#import "AFSetting.h"
#import "AFBaseSetting.h"
#import "AFStringListPickerViewController.h"
#import "AFViewPanelSetting.h"

@interface AFStringListSetting : AFViewPanelSetting <AFSetting>
{
}

- (id)initWithIdentity:(NSString *)identityIn
                 title:(NSString *)titleIn
            stringList:(NSArray *)stringListIn
             labelIcon:(UIImage *)icon;

@end
