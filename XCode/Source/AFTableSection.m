
#import "AFTableSection.h"
#import "AFTable.h"
#import "AFCellSelectionDelegate.h"
#import "AFTableSectionObserver.h"
#import "AFThemeManager.h"

static UIColor* headerColor				= nil;
static UIColor* headerShadowColor		= nil;
static NSNumber* headerShadowEnabled	= nil;

@implementation AFTableSection

+(UIColor*)headerColor
{
	if(!headerColor)headerColor = [[AFThemeManager themeSectionForClass:[AFTableSection class]] colorForKey:THEME_KEY_HEADER_COLOR];
	return headerColor;
}

+(UIColor*)headerShadowColor
{
	if(!headerShadowColor)headerShadowColor = [[AFThemeManager themeSectionForClass:[AFTableSection class]] colorForKey:THEME_KEY_HEADER_SHADOW_COLOR];
	return headerShadowColor;
}

+(BOOL)headerShadowEnabled
{
	if(!headerShadowEnabled)headerShadowEnabled = [[AFThemeManager themeSectionForClass:[AFTableSection class]] valueForKey:THEME_KEY_HEADER_SHADOW_ENABLED];
	return [headerShadowEnabled boolValue];
}

-(id)initWithTitle:(NSString*)titleIn
{
	if((self = [super init]))
	{
		title = [titleIn retain];
		children = [[NSMutableArray alloc] init];
		observers = [[NSMutableSet alloc] init];
		parentTable = nil;
	}
	return self;
}

-(AFTableCell*)cellAtIndex:(NSInteger)index 
{
	return [children objectAtIndex:index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)lenIn
{
	int len = [children count];
	id* childrenCopy = malloc(sizeof(id)*len);
	[children getObjects:childrenCopy range:NSMakeRange(0, len)];
	
	if(state->state >= len)return 0;
    state->itemsPtr = childrenCopy;
    state->state = len;
    state->mutationsPtr = (unsigned long *)self;
    return len;
	
	/*
	len = len<[children count]?len:[children count];
	stackbuf = malloc(sizeof(AFTableCell*)*len);
	[children getObjects:stackbuf range:NSMakeRange(0,len)];
	return len;
	 */
}

-(void)addCell:(AFTableCell*)cell
{
	cell.parentSection = self;
	[children addObject:cell];
	[cell willBeAdded];
	[self editMade];
}

-(void)removeCell:(AFTableCell*)cell
{
	[children removeObject:cell];
	[cell willBeRemoved];
	[self editMade];
}

-(int)cellCount{return [children count];}

-(void)removeAllCells
{
	[self beginBlockEdit];
	NSArray* removeList = [NSArray arrayWithArray:children];
	for(AFTableCell* cell in removeList)[self removeCell:cell];
	[self endBlockEdit];
}

//============>> Themeable

-(void)themeChanged
{
	headerColor = nil;
	headerShadowColor = nil;
}

+(Class<AFThemeable>)themeParentSectionClass{return [AFTable class];}
+(NSString*)themeSectionName{return nil;}
+(NSDictionary*)defaultThemeSection
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
	@"FFFFFF",						THEME_KEY_HEADER_COLOR,
	@"000000",						THEME_KEY_HEADER_SHADOW_COLOR,
	[NSNumber numberWithBool:NO],	THEME_KEY_HEADER_SHADOW_ENABLED,
	nil];
}

//======>> Dealloc

-(void)dealloc
{
	//[selectionTargets release];
	[children release];
	[title release];
	[observers release];
	[super dealloc];
}

@synthesize title, children, parentTable; //selectionTargets;

@end
