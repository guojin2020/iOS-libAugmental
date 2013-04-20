#import <Foundation/Foundation.h>
#import "AFViewPanelField.h"
#import "AFField.h"
#import "AFDatePickerViewController.h"
#import "AFPThemeable.h"

#define THEME_KEY_DATE_ICON @"dateIcon"

@protocol AFFieldPersistenceDelegate;

@interface AFDateField : AFViewPanelField <AFPThemeable>
{
    NSDateFormatter *dateFormatter;
}

- (id)initWithId:(NSString *)identityIn;

+ (UIImage *)dateIcon;

@end
