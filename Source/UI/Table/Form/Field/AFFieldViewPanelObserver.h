#import <UIKit/UIKit.h>

@class AFFieldViewPanelController;

@protocol AFFieldViewPanelObserver

- (void)settingViewPanel:(AFFieldViewPanelController *)viewPanelController valueChanged:(NSObject *)newValue;

@end
