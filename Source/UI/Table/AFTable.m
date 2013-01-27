
#import "AFTable.h"

#import "AFTableSection.h"
#import "AFTableViewController.h"

SEL AFTableEventEdited;

@implementation AFTable

+(void)initialize
{
    AFTableEventEdited = @selector(handleTableEdited:); //Table
}

-(id)init
{
    self = [super init];
    if(self)
    {
        title = @"";
        children = [[NSMutableArray alloc] init];
        viewController = NULL;
    }
    return self;
}

-(id)initWithTitle:(NSString*)titleIn
{
    return [self initWithTitle:titleIn backTitle:nil];
}

-(id)initWithTitle:(NSString*)titleIn backTitle:(NSString*)backTitleIn
{
	if((self = [self init]))
	{
		title     = [titleIn retain];
		backTitle = [backTitleIn retain];

        [self notifyObservers:AFTableEventEdited parameters:nil];
	}
	return self;
}

-(void)insertSection:(AFTableSection*)group atIndex:(NSUInteger)index
{
	group.parentTable = self;
	[children insertObject:group atIndex:index];
	[group addObserver:self];
    [self notifyObservers:AFTableEventEdited parameters:nil];
}

-(void)addSection:(AFTableSection*)group
{
	group.parentTable = self;
	[children addObject:group];
	[group addObserver:self];
    [self notifyObservers:AFTableEventEdited parameters:nil];
}

-(void)removeSection:(AFTableSection*)group
{
	if(group.parentTable==self) group.parentTable = nil;
	[children removeObject:group];
	[group removeObserver:self];
    [self notifyObservers:AFTableEventEdited parameters:nil];
}

-(BOOL)containsSection:(AFTableSection*)section{return [children containsObject:section];}

-(void)clear
{
	[children removeAllObjects];
    [self notifyObservers:AFTableEventEdited parameters:nil];
}

-(AFTableSection*)sectionAtIndex:(NSUInteger)index
{
	return (AFTableSection*)[children objectAtIndex:index];
}

-(NSUInteger)sectionCount{return [children count];}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id[])stackbuf count:(NSUInteger)lenIn
{
	NSUInteger len = [children count];
	id* childrenCopy = malloc(sizeof(id)*len);
	[children getObjects:childrenCopy range:NSMakeRange(0, len)];
	
	if(state->state >= len)return 0;
    state->itemsPtr = childrenCopy;
    state->state = len;
    state->mutationsPtr = (unsigned long *)self;
    return len;
}

//=======>> Themeable Implementation

-(void)themeChanged{}
+(id<AFThemeable>)themeParentSectionClass{return nil;}
+(NSString*)themeSectionName{return @"table";}

+(NSDictionary*)defaultThemeSection
{
    return [NSDictionary dictionary];
}

//=========>> Views

-(AFTableViewController*)viewController
{
    if(!viewController)
    {
        viewController = [[AFTableViewController alloc] initWithTable:self style:UITableViewStylePlain];
    }
    return viewController;
}

-(UITableView*)tableView
{
    return (UITableView*)([self viewController].view);
}

-(void)dealloc
{
    [viewController release];
	[children release];
	[title release];
    [backTitle release];
    [backTitle release];
    [super dealloc];
}

@synthesize title, backTitle, viewController;

@end
