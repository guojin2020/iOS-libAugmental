@interface AFCellViewFactory : NSObject
{
    NSMutableDictionary *viewTemplateStore;
}

+ (AFCellViewFactory *)defaultFactory;

- (id)initWithNib:(NSString *)aNibName;

//-(UITableViewCell*)cellOfKind: (NSString*)theCellKind forTable: (UITableView*)aTableView;
- (UITableViewCell *)cellOfKind:(NSString *)theCellKind forTable:(UITableView *)aTableView reuseIdentifier:(NSString *)reuseIdentifier;

@end 
