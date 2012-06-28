#import <UIKit/UIKit.h>

@interface AFTableAlert : UIAlertView <UITableViewDelegate>
{
    id<UITableViewDataSource> _tableData;
    id<UITableViewDelegate> _tableDelegate;

    @private
    
    UITableView *table;
}

-(void)reloadTableData;

@property (nonatomic, assign, setter=setTableData:) id<UITableViewDataSource> tableData;
@property (nonatomic, assign, setter=setTableDelegate:) id<UITableViewDelegate> tableDelegate;

@end
