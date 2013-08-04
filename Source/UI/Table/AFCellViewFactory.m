#import "AFCellViewFactory.h"

@implementation AFCellViewFactory

static AFCellViewFactory *factorySingleton;

+ (AFCellViewFactory *)defaultFactory
{
    return factorySingleton ?: (factorySingleton = [[AFCellViewFactory alloc] initWithNib:@"AFCellViews"]);
}

- (id)initWithNib:(NSString *)aNibName
{
    self = [self init];
    if (self)
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
                else @throw [NSException exceptionWithName:@"Unknown _viewCell" reason:@"pruneCellCache has no reuseIdentifier" userInfo:nil];
            }
        }
    }
    return self;
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

@end
