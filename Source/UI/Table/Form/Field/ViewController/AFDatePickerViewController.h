#import <Foundation/Foundation.h>
#import "AFFieldViewPanelController.h"

@class AFViewPanelField;
@class AFField;

@interface AFDatePickerViewController : AFFieldViewPanelController
{
    UIDatePicker *picker;
    UITextView   *adviceText;
}

- (id)initWithTitle:(NSString *)titleIn;

- (void)datePickerValueChanged;

@property(nonatomic, strong) IBOutlet UIDatePicker *picker;
@property(nonatomic, strong) IBOutlet UITextView   *adviceText;

@end
