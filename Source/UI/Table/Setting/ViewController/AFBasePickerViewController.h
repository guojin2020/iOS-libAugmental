#import <UIKit/UIKit.h>
#import "AFObjectPickerDelegate.h"
#import "AFSettingViewPanelController.h"
#import "AFThemeable.h"

#define THEME_KEY_TEXT_COLOR    @"textColor"
#define THEME_KEY_BG_COLOR        @"bgColor"

@class AFViewPanelSetting;

@interface AFBasePickerViewController : AFSettingViewPanelController <UIPickerViewDataSource, UIPickerViewDelegate, AFThemeable>
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


@property(nonatomic, retain) IBOutlet UIPickerView *picker;
@property(nonatomic, retain) IBOutlet UITextView   *adviceText;

@property(nonatomic, retain) NSArray *objects;

@end
