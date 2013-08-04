#import <Foundation/Foundation.h>
#import "AFField.h"
#import "AFFieldViewPanelController.h"

@class AFViewPanelField;

@interface AFMMYYDatePickerViewController : AFFieldViewPanelController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UITextView           *adviceText;
    UIPickerView         *picker;
    AFField              *setting;
    NSArray              *yearStrings;
    NSArray              *monthStrings;
}

- (id)initWithTitle:(NSString *)titleIn
           observer:(NSObject <AFFieldViewPanelObserver> *)observerIn
          yearRange:(NSRange)range;

@property(nonatomic, strong) IBOutlet UIPickerView *picker;
@property(nonatomic, strong) IBOutlet UITextView   *adviceText;

@end
