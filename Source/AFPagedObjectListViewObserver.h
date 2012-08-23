
#import <UIKit/UIKit.h>
#import "AFObject.h"
#import "AFPagedObjectListViewController.h"
#import "AFObjectTableCell.h"

@protocol AFPagedObjectListViewObserver

-(void)pageRefreshWillStart:(AFPagedObjectListViewController*)objectListViewController;
-(void)cellAdded:(NSObject<AFObjectTableCell>*)cell toPage:(AFPagedObjectListViewController*)objectListViewController;
-(void)pageRefreshDidFinish:(AFPagedObjectListViewController*)objectListViewController;

@end
