#import "AFObject.h"

@protocol AFObjectViewPanelController;

@protocol AFPanelViewableObject

+ (id<AFObjectViewPanelController>)viewPanelClass;

@end
