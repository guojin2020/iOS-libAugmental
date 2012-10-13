#import "AFObject.h"

@protocol AFObjectViewPanelController;

@protocol AFObject_PanelViewable <AFObject>

+ (id<AFObjectViewPanelController>)viewPanelClass;

@end
