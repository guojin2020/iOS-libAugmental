
#import "AFTableSection.h"
#import "AFTable.h"
#import "AFThemeManager.h"

static UIColor* headerColor				= nil;
static UIColor* headerShadowColor		= nil;
static NSNumber* headerShadowEnabled	= nil;

SEL AFTableSectionEventEdited;

@implementation AFTableSection

+(void)load
{
    AFTableSectionEventEdited = @selector(handleTableSectionEdited:); //TableSection
}

+(UIColor*)headerColor
{
	if(!headerColor)headerColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableSection class]] colorForKey:THEME_KEY_HEADER_COLOR];
	return headerColor;
}

+(UIColor*)headerShadowColor
{
	if(!headerShadowColor)headerShadowColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableSection class]] colorForKey:THEME_KEY_HEADER_SHADOW_COLOR];
	return headerShadowColor;
}

+(BOOL)headerShadowEnabled
{
	if(!headerShadowEnabled)headerShadowEnabled = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTableSection class]] valueForKey:THEME_KEY_HEADER_SHADOW_ENABLED];
	return [headerShadowEnabled boolValue];
}

-(id)init
{
    self=[super init];
    if(self)
    {
        title       = @"";
        children    = [NSMutableArray new];
        parentTable = nil;
    }
    return self;
}

-(id)initWithTitle:(NSString*)titleIn
{
	if((self = [self init]))
	{
		title = [titleIn retain];
	}
	return self;
}

-(AFTableCell*)cellAtIndex:(NSUInteger)index
{
	return [children objectAtIndex:index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)lenIn
{
	NSUInteger len = [children count];
	id* childrenCopy = malloc(sizeof(id)*len);
	[children getObjects:childrenCopy range:NSMakeRange(0, len)];

	if(state->state >= len)return 0;
	state->itemsPtr = childrenCopy;
	state->state = (unsigned long) len;
	state->mutationsPtr = (unsigned long *)self;
	return len;
}

-(NSInteger)indexOf:(AFTableCell *)cell
{
	NSAssert([children containsObject:cell],@"Internal inconsistency");

	return [children indexOfObject:cell];
}

-(void)addCell:(AFTableCell*)cell
{
	@synchronized (parentTable)
	{
		cell.parentSection = self;
		[children addObject:cell];
		[cell willBeAdded];
	    [self notifyObservers:AFTableSectionEventEdited parameters:self, nil];
	}
}

-(void)removeCell:(AFTableCell*)cell
{
	@synchronized (parentTable)
	{
		[children removeObject:cell];
		[cell willBeRemoved];
	    [self notifyObservers:AFTableSectionEventEdited parameters:self, nil];
	}
}

-(int)cellCount
{
	return [children count];
}

-(void)removeAllCells
{
	@synchronized (parentTable)
	{
		[self beginAtomic];
		NSArray* removeList = [NSArray arrayWithArray:children];
		for(AFTableCell* cell in removeList)[self removeCell:cell];
		[self completeAtomic];
	}
}

//============>> Themeable

-(void)themeChanged
{
	headerColor = nil;
	headerShadowColor = nil;
}

+(id<AFPThemeable>)themeParentSectionClass{return (id<AFPThemeable>)[AFTable class];}
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
    [parentTable release];
    [super dealloc];
}

@synthesize title, children, parentTable; //selectionTargets;

@end
