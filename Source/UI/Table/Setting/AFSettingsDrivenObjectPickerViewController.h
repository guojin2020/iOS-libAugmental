#import <Foundation/Foundation.h>
#import "AFBasePickerViewController.h"
#import "AFRequestEndpoint.h"
#import "AFEventObserver.h"
#import "AFObjectPickerDelegate.h"
#import "AFSettingViewPanelObserver.h"
#import "AFObject.h"

@interface AFSettingsDrivenObjectPickerViewController : AFBasePickerViewController <AFRequestEndpoint, AFEventObserver, AFObjectPickerDelegate, AFSettingViewPanelObserver>
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
