#import <Foundation/Foundation.h>
#import "AFField.h"
#import "AFBaseField.h"
#import "AFStringListPickerViewController.h"
#import "AFViewPanelField.h"

@interface AFStringListField : AFViewPanelField <AFField>
{
}

- (id)initWithIdentity:(NSString *)identityIn
                 title:(NSString *)titleIn
            stringList:(NSArray *)stringListIn
             labelIcon:(UIImage *)icon;

@end
