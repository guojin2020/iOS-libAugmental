
#import <Foundation/Foundation.h>
#import "AFTableAlert.h"

@class AFRequestQueue;

@interface AFRequestQueueAlertView : AFTableAlert <UITableViewDataSource, UITableViewDelegate>
{
    AFRequestQueue* queue;
    NSArray* activatedRequestCache;
    UITableViewCell* headingRow;
}

+(void)showAlertForQueue:(AFRequestQueue*)queueIn;

-(id)initWithRequestQueue:(AFRequestQueue*)requestQueue;

@end
