
#import "AFTable.h"
#import "AFTableSection.h"
#import "AFEditableObserver.h"
#import "AFTableViewController.h"

@implementation AFTable

-(id)initWithTitle:(NSString*)titleIn
{
	if((self = [self initWithTitle:titleIn backTitle:nil]))
	{
	}
	return self;
}

-(id)initWithTitle:(NSString*)titleIn backTitle:(NSString*)backTitleIn
{
	if((self = [self init]))
	{
		title = [titleIn retain];
		children = [[NSMutableArray alloc] init];
		observers = [[NSMutableSet alloc] init];
		blockEdit = NO;
		editMade = NO;
		backTitle = [backTitleIn retain];
	}
	return self;
}

-(void)editableChanged:(AFBlockEditableObject*)tableSection
{
	[self broadcastChangeToObservers];
}

-(void)insertSection:(AFTableSection*)group atIndex:(int)index
{
	group.parentTable = self;
	[children insertObject:group atIndex:index];
	[group addObserver:self];
	[self editMade];
}

-(void)addSection:(AFTableSection*)group
{
	group.parentTable = self;
	[children addObject:group];
	[group addObserver:self];
	[self editMade];
}

-(void)removeSection:(AFTableSection*)group
{
	if(group.parentTable==self) group.parentTable = nil;
	[children removeObject:group];
	[group removeObserver:self];
	[self editMade];
}

-(BOOL)containsSection:(AFTableSection*)section{return [children containsObject:section];}

-(void)clear
{
	[children removeAllObjects];
	[self editMade];
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

//=========>> Dealloc

-(void)dealloc
{
	[observers release];
	[children release];
	[title release];
	[super dealloc];
}

@synthesize title, backTitle, parentController;

@end
