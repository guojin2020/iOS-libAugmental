#import "AFCellViewFactory.h"

@implementation AFCellViewFactory

static AFCellViewFactory *factorySingleton;

+ (void)initialize
{
    factorySingleton = [[AFCellViewFactory alloc] initWithNib:@"AFCellViews"];
}

+ (AFCellViewFactory *)defaultFactory
{return factorySingleton;}

- (id)initWithNib:(NSString *)aNibName
{
    if ((self = [super init]))
    {
        viewTemplateStore = [[NSMutableDictionary alloc] initWithCapacity:1];
        NSArray *templates = [[NSBundle mainBundle] loadNibNamed:aNibName owner:self options:nil];
        for (id template in templates)
        {
            if ([template isKindOfClass:[UITableViewCell class]])
            {
                UITableViewCell *cellTemplate = (UITableViewCell *) template;
                NSString        *key          = cellTemplate.reuseIdentifier;
                if (key) [viewTemplateStore setObject:[NSKeyedArchiver archivedDataWithRootObject:template] forKey:key];
                else @throw [NSException exceptionWithName:@"Unknown cell" reason:@"Cell has no reuseIdentifier" userInfo:nil];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [viewTemplateStore release];
    [super dealloc];
}

- (UITableViewCell *)cellOfKind:(NSString *)theCellKind forTable:(UITableView *)aTableView reuseIdentifier:(NSString *)reuseIdentifier
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (!cell)
    {
        NSData *cellData = [viewTemplateStore objectForKey:theCellKind];
        if (cellData)
        {
            cell = [NSKeyedUnarchiver unarchiveObjectWithData:cellData];
        }

    }

    return cell;
}
/*
-(UITableViewCell*)cellOfKind: (NSString*)theCellKind forTable: (UITableView*)aTableView  
{  
  return [self cellOfKind:theCellKind forTable:aTableView reuseIdentifier:theCellKind]; //[NSString stringWithFormat:@"%i",[aTableView hash]]
}
*/
@end
