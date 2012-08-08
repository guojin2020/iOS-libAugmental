
#import "AFViewPanelSetting.h"
#import "AFImageCache.h"
#import "AFCellViewFactory.h"
#import "AFSettingViewPanelController.h"
#import "AFTableCell.h"
#import "AFTableSection.h"
#import "AFTable.h"
#import "AFTableViewController.h"
#import "AFThemeManager.h"
#import "AFBaseSetting.h"

static UIImage* editIcon = nil;

@implementation AFViewPanelSetting

-(id)initWithIdentity:(NSString*)identityIn
			labelText:(NSString*)labelTextIn
			labelIcon:(UIImage*)labelIconIn
   panelViewController:(AFSettingViewPanelController*)panelViewControllerIn
{
	NSAssert1(identityIn&&labelTextIn&&panelViewControllerIn,@"Bad paramters when initialising %@",NSStringFromClass([self class]));
	
	if((self=[super initWithIdentity:identityIn]))
	{
		labelText			= [labelTextIn retain];
		labelIcon			= [labelIconIn retain];
		panelViewController	= [panelViewControllerIn retain];

		[panelViewController addObserver:self];
	}
	return self;
}

//Protect subclasses from bad instantiation via BaseSettings constructors
-(id)initWithIdentity:(NSString*)identityIn
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn;
{
	if(!cell||tableView!=tableIn)
	{
		self.tableView = tableIn;
		self.cell = [super viewCellForTableView:tableIn templateName:@"editableOptionCell"];
		
		//Reassign components
		[optionLabel release];
		[valueLabel release];
		[editableOptionIcon release];
		
		optionLabel				= [(UILabel*)[cell viewWithTag:1] retain];
		valueLabel				= [(UILabel*)[cell viewWithTag:2] retain];
		editableOptionIcon		= [(UIImageView*)[cell viewWithTag:3] retain];
		
		[optionLabel setTextColor:[AFTableCell defaultTextColor]];
		[valueLabel setTextColor:[AFTableCell defaultTextColor]];
		
		UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[AFViewPanelSetting editIcon]];
		cell.accessoryView = accessoryView;
		[accessoryView release];
		
		if(labelText) optionLabel.text = labelText;
		if(labelIcon) editableOptionIcon.image = labelIcon;
		
		[self updateControlCell];
	}
	return cell;
}

-(void)setValue:(NSObject <NSCoding>*)valueIn
{
	[super setValue:valueIn];
	[panelViewController setValue:valueIn];
}

-(void)settingViewPanel:(AFSettingViewPanelController*)viewPanelController valueChanged:(NSObject<NSCoding>*)newValue
{
	[self setValue:newValue];
}

-(NSString*)valueString{return valueLabel.text;}
-(void)setValueString:(NSString*)string{valueLabel.text=string;}

-(void)wasSelected
{
	if(panelViewController)
	{
		UINavigationController* navController = self.parentSection.parentTable.viewController.navigationController;
		[navController pushViewController:panelViewController animated:YES];
	}
}

//=====>> Theme Getter

+(UIImage*)editIcon
{
	if(!editIcon)editIcon=[[AFThemeManager themeSectionForClass:[AFViewPanelSetting class]] imageForKey:THEME_KEY_EDIT_ICON];
	return editIcon;
}

//=====>> Themeable

-(void)themeChanged{editIcon=nil;}
+(Class<AFThemeable>)themeParentSectionClass{return [AFBaseSetting class];}
+(NSString*)themeSectionName{return nil;}
+(NSDictionary*)defaultThemeSection
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
	@"editIcon16",THEME_KEY_EDIT_ICON,
	nil];
}

//=====>> Dealloc

-(void)dealloc
{
	[panelViewController removeObserver:self];
	[panelViewController release];
	[labelIcon release];
	[optionLabel release];
	[valueLabel release];
	[editableOptionIcon release];
    [valueString release];
    [super dealloc];
}

@synthesize valueString;

@end
