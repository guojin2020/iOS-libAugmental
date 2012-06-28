
#import <Foundation/Foundation.h>
#import "AFSetting.h"
#import "AFSettingViewPanelController.h"

@class AFViewPanelSetting;

@interface AFMMYYDatePickerViewController : AFSettingViewPanelController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	UITextView* adviceText;
	UIPickerView* picker;
	NSObject<AFSetting>* setting;
	NSArray* yearStrings;
	NSArray* monthStrings;
}

-(id)initWithTitle:(NSString*)titleIn
		  observer:(NSObject<AFSettingViewPanelObserver>*)observerIn
yearRange:(NSRange)range;

@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) IBOutlet UITextView* adviceText;

@end
