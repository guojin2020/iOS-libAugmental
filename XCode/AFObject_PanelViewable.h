
#import "AFObject.h"

@protocol AFObjectViewPanelController;

@protocol AFObject_PanelViewable <AFObject>

+(Class<AFObjectViewPanelController>)viewPanelClass;

@end
