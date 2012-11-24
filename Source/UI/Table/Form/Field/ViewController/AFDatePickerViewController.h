#import <Foundation/Foundation.h>
#import "AFFieldViewPanelController.h"

@class AFViewPanelField;
@protocol AFField;

@interface AFDatePickerViewController : AFFieldViewPanelController
{
    UIDatePicker *picker;
    UITextView   *adviceText;
}

- (id)initWithTitle:(NSString *)titleIn;

- (void)datePickerValueChanged;

@property(nonatomic, retain) IBOutlet UIDatePicker *picker;
@property(nonatomic, retain) IBOutlet UITextView   *adviceText;

@end
