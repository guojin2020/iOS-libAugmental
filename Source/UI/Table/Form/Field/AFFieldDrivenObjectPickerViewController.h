#import <Foundation/Foundation.h>
#import "AFBasePickerViewController.h"
#import "AFRequestEndpoint.h"
#import "AFEventObserver.h"
#import "AFObjectPickerDelegate.h"
#import "AFFieldViewPanelObserver.h"
#import "AFObject.h"

@interface AFFieldDrivenObjectPickerViewController : AFBasePickerViewController <AFRequestEndpoint, AFEventObserver, AFObjectPickerDelegate, AFFieldViewPanelObserver>
{
    NSString *getObjectActionString;
    NSString *objectCSVIdListSettingsKey;
    NSString *objectDefaultSelectionIdKey;
    id<AFObject> objectClass;
}

- (id)  initWithTitle:(NSString *)title
     getObjectActionString:(NSString *)getObjectActionStringIn
 objectCSVIdListSettingsKey:(NSString *)objectCSVIdListSettingsKeyIn
objectDefaultSelectionIdKey:(NSString *)objectDefaultSelectionIdKeyIn
                objectClass:(id <AFObject>)objectClassIn;

@end
