#import <UIKit/UIKit.h>

@interface AFTableAlert : UIAlertView <UITableViewDelegate>
{
    id<UITableViewDataSource> __weak _tableData;
    id<UITableViewDelegate> __weak _tableDelegate;

    @private
    
    UITableView *table;
}

-(void)reloadTableData;

@property (nonatomic, weak, setter=setTableData:) id<UITableViewDataSource> tableData;
@property (nonatomic, weak, setter=setTableDelegate:) id<UITableViewDelegate> tableDelegate;

@end
