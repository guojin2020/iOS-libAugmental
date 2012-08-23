
#import <Foundation/Foundation.h>
#import "AFObjectPickerDelegate.h"
#import "AFBasePickerViewController.h"

@interface AFStringListPickerViewController : AFBasePickerViewController <AFObjectPickerDelegate>
{
	NSMutableDictionary* classes;
}

-(id)initWithStrings:(NSArray*)objectsIn
			   title:(NSString*)titleIn;

@end
