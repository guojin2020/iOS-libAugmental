#import <UIKit/UIKit.h>

@class AFSettingViewPanelController;

@protocol AFSettingViewPanelObserver

- (void)settingViewPanel:(AFSettingViewPanelController *)viewPanelController valueChanged:(NSObject *)newValue;

@end
