
#import <Foundation/Foundation.h>
#import "AFBasePickerViewController.h"
#import "AFRequestEndpoint.h"
#import "AFEventObserver.h"
#import "AFObjectPickerDelegate.h"
#import "AFSettingViewPanelObserver.h"

@interface AFSettingsDrivenObjectPickerViewController : AFBasePickerViewController <AFRequestEndpoint, AFEventObserver, AFObjectPickerDelegate, AFSettingViewPanelObserver>
{
	NSString* getObjectActionString;
	NSString* objectCSVIdListSettingsKey;
	NSString* objectDefaultSelectionIdKey;
	Class objectClass;
}

-(id)			initWithTitle:(NSString*)title
		getObjectActionString:(NSString*)getObjectActionStringIn
   objectCSVIdListSettingsKey:(NSString*)objectCSVIdListSettingsKeyIn
  objectDefaultSelectionIdKey:(NSString*)objectDefaultSelectionIdKeyIn
			      objectClass:(Class)objectClassIn;

@end
