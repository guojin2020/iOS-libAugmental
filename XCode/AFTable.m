
#import "AFTable.h"

#import "AFTableSection.h"
#import "AFEditableObserver.h"
#import "AFTableViewController.h"
#import "AFChangeFlag.h"

static AFChangeFlag* FLAG_TABLE_EDITED;

@implementation AFTable

+(void)initialize
{
    FLAG_TABLE_EDITED = [AFChangeFlag new];
}

-(id)init { return [self initWithTitle:@""]; }
-(id)initWithTitle:(NSString*)titleIn { return [self initWithTitle:titleIn backTitle:nil]; }

-(id)initWithTitle:(NSString*)titleIn backTitle:(NSString*)backTitleIn
{
	if((self = [super init]))
	{
		title = [titleIn retain];
		children = [[NSMutableArray alloc] init];

        [self notifyObservers:FLAG_TABLE_EDITED parameters:nil];
        
		backTitle = [backTitleIn retain];
        viewController = NULL;
	}
	return self;
}

-(void)insertSection:(AFTableSection*)group atIndex:(int)index
{
	group.parentTable = self;
	[children insertObject:group atIndex:index];
	[group addObserver:self];
	[self notifyObservers:FLAG_TABLE_EDITED parameters:nil];
}

-(void)addSection:(AFTableSection*)group
{
	group.parentTable = self;
	[children addObject:group];
	[group addObserver:self];
    [self notifyObservers:FLAG_TABLE_EDITED parameters:nil];
}

-(void)removeSection:(AFTableSection*)group
{
	if(group.parentTable==self) group.parentTable = nil;
	[children removeObject:group];
	[group removeObserver:self];
    [self notifyObservers:FLAG_TABLE_EDITED parameters:nil];
}

-(BOOL)containsSection:(AFTableSection*)section{return [children containsObject:section];}

-(void)clear
{
	[children removeAllObjects];
    [self notifyObservers:FLAG_TABLE_EDITED parameters:nil];
}

-(AFTableSection*)sectionAtIndex:(NSInteger)index
{
	return (AFTableSection*)[children objectAtIndex:index];
}

-(NSInteger)sectionCount{return [children count];}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)lenIn
{
	int len = [children count];
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
+(Class<AFThemeable>)themeParentSectionClass{return nil;}
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

//=========>> Dealloc

- (void)change:(AFChangeFlag *)changeFlag wasFiredBySource:(AFObservable *)observable withParameters:(NSArray*)parameters
{

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
