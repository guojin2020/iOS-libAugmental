
#import <Foundation/Foundation.h>
#import "AFSettingViewPanelController.h"

@class AFViewPanelSetting;
@protocol AFSetting;

@interface AFDatePickerViewController : AFSettingViewPanelController
{
	UIDatePicker* picker;
	UITextView* adviceText;
}

-(id)initWithTitle:(NSString*)titleIn;
-(void)datePickerValueChanged;

@property (nonatomic, retain) IBOutlet UIDatePicker* picker;
@property (nonatomic, retain) IBOutlet UITextView* adviceText;

@end
