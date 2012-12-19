#import <Foundation/Foundation.h>
#import "AFObjectPickerDelegate.h"
#import "AFPickerViewController.h"

@interface AFStringListPickerViewController : AFPickerViewController <AFObjectPickerDelegate>
{
    NSMutableDictionary *classes;
}

- (id)initWithStrings:(NSArray *)objectsIn
                title:(NSString *)titleIn;

@end
