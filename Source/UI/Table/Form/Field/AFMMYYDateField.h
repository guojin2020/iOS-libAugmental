#import <Foundation/Foundation.h>
#import "AFViewPanelField.h"
#import "AFField.h"
#import "AFPThemeable.h"

@protocol AFFieldPersistenceDelegate;

#define THEME_KEY_DATE_ICON @"dateIcon"

@interface AFMMYYDateField : AFViewPanelField <AFPThemeable>
{
}

- (id)initWithId:(NSString *)identityIn yearRange:(NSRange)rangeIn;

+ (UIImage *)dateIcon;

@end
