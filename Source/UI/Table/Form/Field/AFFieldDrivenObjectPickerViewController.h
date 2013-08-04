#import <Foundation/Foundation.h>
#import "AFPickerViewController.h"
#import "AFRequestEndpoint.h"
#import "AFObjectPickerDelegate.h"
#import "AFFieldViewPanelObserver.h"
#import "AFObject.h"

@interface AFFieldDrivenObjectPickerViewController : AFPickerViewController <AFRequestEndpoint, AFObjectPickerDelegate, AFFieldViewPanelObserver>
{
    NSString *getObjectActionString;
    NSString *objectCSVIdListSettingsKey;
    NSString *objectDefaultSelectionIdKey;
    Class objectClass;
}

- (id)  initWithTitle:(NSString *)title
     getObjectActionString:(NSString *)getObjectActionStringIn
 objectCSVIdListSettingsKey:(NSString *)objectCSVIdListSettingsKeyIn
objectDefaultSelectionIdKey:(NSString *)objectDefaultSelectionIdKeyIn
                objectClass:(Class)objectClassIn;

-(void)handleAppSettingsLoaded;

@end
