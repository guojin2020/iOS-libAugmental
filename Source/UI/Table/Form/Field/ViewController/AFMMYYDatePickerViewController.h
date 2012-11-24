#import <Foundation/Foundation.h>
#import "AFField.h"
#import "AFFieldViewPanelController.h"

@class AFViewPanelField;

@interface AFMMYYDatePickerViewController : AFFieldViewPanelController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UITextView           *adviceText;
    UIPickerView         *picker;
    NSObject <AFField> *setting;
    NSArray              *yearStrings;
    NSArray              *monthStrings;
}

- (id)initWithTitle:(NSString *)titleIn
           observer:(NSObject <AFFieldViewPanelObserver> *)observerIn
          yearRange:(NSRange)range;

@property(nonatomic, retain) IBOutlet UIPickerView *picker;
@property(nonatomic, retain) IBOutlet UITextView   *adviceText;

@end
