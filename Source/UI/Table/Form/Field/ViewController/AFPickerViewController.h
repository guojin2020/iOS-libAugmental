#import <UIKit/UIKit.h>
#import "AFObjectPickerDelegate.h"
#import "AFFieldViewPanelController.h"
#import "AFPThemeable.h"

#define THEME_KEY_TEXT_COLOR    @"textColor"
#define THEME_KEY_BG_COLOR        @"bgColor"

@class AFViewPanelField;

@interface AFPickerViewController : AFFieldViewPanelController <UIPickerViewDataSource, UIPickerViewDelegate, AFPThemeable>
{
    NSArray                           *objects;
    UIPickerView                      *picker;
    UITextView                        *adviceText;
    NSObject <AFObjectPickerDelegate> *delegate;
}

+ (UIColor *)textColor;

+ (UIColor *)bgColor;

- (id)initWithObjects:(NSArray *)objectsIn
             delegate:(NSObject <AFObjectPickerDelegate> *)delegate
                title:(NSString *)titleIn;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;


@property(nonatomic, strong) IBOutlet UIPickerView *picker;
@property(nonatomic, strong) IBOutlet UITextView   *adviceText;

@property(nonatomic, strong) NSArray *objects;

@end
