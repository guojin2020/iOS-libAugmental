#import "AFTableCell.h"
#import "AFCellSelectionDelegate.h"
#import "AFTableCellBackgroundView.h"
#import "AFCellViewFactory.h"
#import "AFAppDelegate.h"
#import "AFTableSection.h"
#import "AFTable.h"
#import "AFTableViewController.h"
#import "AFThemeManager.h"

static UIColor* defaultTextColor			= nil;
static UIColor* defaultSecondaryTextColor	= nil;
static UIColor* defaultBGColor				= nil;
static UIFont*	defaultTextFont				= nil;
static float_t	defaultTextSize				= -1.0;
static NSString* cellClickedSound			= nil;

@implementation AFTableCell

-(id)init
{
	if((self=[super init]))
	{
		fillColor	= [AFTableCellBackgroundView defaultBackgroundColor];
		labelText	= @"";
		tableView	= nil;
		cell		= nil;
		height		= -1.0f;
        
        [AFThemeManager addObserver:self];
        [self themeChanged];
	}
	return self;
}

-(id)initWithLabelText:(NSString*)labelTextIn
{
	if((self=[super init]))
	{
		labelText=[labelTextIn retain];
		
		tableView=nil;
		cell=nil;
		
		if([self conformsToProtocol:@protocol(AFCellSelectionDelegate)])
		{
			selectionDelegate = (NSObject<AFCellSelectionDelegate>*)self; //Default selection delegate to self if appropriate
		}
	}
	return self;
}

- (void)refresh
{
    [self.cell setNeedsLayout];
}

-(BOOL)deleteSelected{return NO;}
-(BOOL)allowsDeletion{return NO;}

-(NSString*)titleForDeleteButton{return @"Delete";}

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn
{
	return [self viewCellForTableView:tableIn templateName:nil];
}

-(UINavigationController*) navigationController { return self.parentSection.parentTable.viewController.navigationController; }

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn templateName:(NSString*)templateNameIn
{
	if(!cell||tableView!=tableIn)
	{
		//Store the table this cell currently belongs to
		self.tableView = tableIn;
		
		//Create the cell, either using the supplied template name, or a blank default
		NSString* reuseIdentifier = [NSString stringWithFormat:@"%i",[self hash]];
		if(templateNameIn)
		{
			self.cell = [[AFCellViewFactory defaultFactory] cellOfKind:templateNameIn forTable:tableIn reuseIdentifier:reuseIdentifier];
		}
		else
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
			if([labelText length]>0) cell.textLabel.text = labelText;
		}
		
		[self viewCellDidLoad];
        [self refresh];
	}
	return cell;
}

-(CGFloat)heightForTableView:(UITableView*)tableIn
{
	return [self viewCellForTableView:tableIn].frame.size.height;
}

-(void)setFillColor:(UIColor*)color
{
	UIColor* oldColor = fillColor;
	fillColor = [color retain];
	if(fillColor!=oldColor) [cell.backgroundView setNeedsDisplay];
}

-(void)accessoryTapped {}

-(void)willBeAdded{}
-(void)willBeRemoved{}

-(void)wasSelected
{
	[AFAppDelegate playSound:[AFTableCell cellClickedSound]];

	if(selectionDelegate)[selectionDelegate cellSelected:self];
}

-(NSString*)cellTemplateName{return nil;}

//=================>> Theme Getters

+(UIColor*)defaultTextColor
{
    if(!defaultTextColor) defaultTextColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFTableCell class]] colorForKey:THEME_KEY_DEFAULT_TEXT_COLOR] retain];
    return defaultTextColor;
}

+(UIColor*)defaultSecondaryTextColor
{
    if(!defaultSecondaryTextColor) defaultSecondaryTextColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFTableCell class]] colorForKey:THEME_KEY_DEFAULT_SECONDARY_TEXT_COLOR] retain];
    return defaultSecondaryTextColor;
}

+(UIColor*)defaultBGColor
{
    if(!defaultBGColor) defaultBGColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFTableCell class]] colorForKey:THEME_KEY_DEFAULT_BG_COLOR] retain];
    return defaultBGColor?:[UIColor clearColor];
}

+(UIFont*)defaultTextFont
{
    if(!defaultTextFont)
    {
        NSString* fontName = [[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFTableCell class]] valueForKey:THEME_KEY_DEFAULT_TEXT_FONT];
        defaultTextFont = [[UIFont fontWithName:fontName size:[AFTableCell defaultTextSize]] retain];
    }
    return defaultTextFont;
}

+(float_t)defaultTextSize
{
    if(defaultTextSize<0) defaultTextSize = [[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFTableCell class]] floatForKey:THEME_KEY_DEFAULT_TEXT_SIZE];
    return defaultTextSize;
}

+(NSString*)cellClickedSound
{
	if(!cellClickedSound)cellClickedSound=[[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFTableCell class]] valueForKey:THEME_KEY_CELL_CLICKED_SOUND] retain];
	return cellClickedSound;
}

-(void)viewCellDidLoad
{
    height = cell.frame.size.height;
    if(height<=0) height = DEFAULT_CELL_HEIGHT;

    //Apply default settings for the look and feel of all cells, e.g. font colour
    cell.textLabel.opaque           = YES;
    cell.textLabel.backgroundColor  = [UIColor clearColor];

    [self setFillColor:[AFTableCell defaultBGColor]];

    //Apply the default background view, more customisable than the Apple default

    UIView* backgroundView  = [[AFTableCellBackgroundView alloc] initWithFrame:CGRectZero usefulTableCell:self];
    cell.backgroundView     = backgroundView;
    [backgroundView release];
}


//=================>> Themeable

-(void)themeChanged
{
    defaultTextColor = nil;
    defaultTextFont = nil;
	defaultSecondaryTextColor = nil;
    defaultTextSize = -1.0;
}

+(id<AFThemeable>)themeParentSectionClass{return (id<AFThemeable>)[AFTable class];}
+(NSString*)themeSectionName{return @"cell";}

+(NSDictionary*)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
    [NSNumber numberWithFloat:17.0f],	THEME_KEY_DEFAULT_TEXT_SIZE,
    @"000000",							THEME_KEY_DEFAULT_TEXT_COLOR,
	@"444444",							THEME_KEY_DEFAULT_SECONDARY_TEXT_COLOR,
    @"Helvetica",						THEME_KEY_DEFAULT_TEXT_FONT,
    @"FFFFFF",							THEME_KEY_DEFAULT_BG_COLOR,nil];
}

//=================>> 

-(void)dealloc
{
	[labelText	release];
	[tableView	release];
	[cell		release];
    [fillColor  release];
    [selectionDelegate release];
    [parentSection release];
    [super		dealloc];
}

@synthesize selectionDelegate, cell, tableView, parentSection, fillColor;

@end
