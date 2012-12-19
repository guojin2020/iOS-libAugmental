#import "AFViewPanelField.h"
#import "AFFieldViewPanelController.h"
#import "AFTable.h"
#import "AFTableViewController.h"
#import "AFThemeManager.h"

static UIImage *editIcon = nil;

@implementation AFViewPanelField

- (id)initWithIdentity:(NSString *)identityIn
             labelText:(NSString *)labelTextIn
             labelIcon:(UIImage *)labelIconIn
   panelViewController:(AFFieldViewPanelController *)panelViewControllerIn
{
    NSAssert1(identityIn && labelTextIn && panelViewControllerIn, @"Bad paramters when initialising %@", NSStringFromClass([self class]));

    if ((self = [super initWithIdentity:identityIn]))
    {
        labelText           = [labelTextIn retain];
        labelIcon           = [labelIconIn retain];
        panelViewController = [panelViewControllerIn retain];

        [panelViewController addObserver:self];
    }
    return self;
}

//Protect subclasses from bad instantiation via BaseSettings constructors
- (id)initWithIdentity:(NSString *)identityIn
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    //Reassign components
    [optionLabel release];
    [valueLabel release];
    [editableOptionIcon release];

    optionLabel        = [(UILabel *) [cell viewWithTag:1] retain];
    valueLabel         = [(UILabel *) [cell viewWithTag:2] retain];
    editableOptionIcon = [(UIImageView *) [cell viewWithTag:3] retain];

    [optionLabel setTextColor:[AFTableCell defaultTextColor]];
    [valueLabel setTextColor:[AFTableCell defaultTextColor]];

    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[AFViewPanelField editIcon]];
    cell.accessoryView = accessoryView;
    [accessoryView release];

    if (labelText) optionLabel.text         = labelText;
    if (labelIcon) editableOptionIcon.image = labelIcon;

    [self updateControlCell];
}


- (void)setValue:(NSObject <NSCoding> *)valueIn
{
    [super setValue:valueIn];
    [panelViewController setValue:valueIn];
}

- (void)settingViewPanel:(AFFieldViewPanelController *)viewPanelController valueChanged:(NSObject *)newValue
{
    NSAssert([newValue conformsToProtocol:@protocol(NSCoding)],@"Internal inconsistency");
    [self setValue:(NSObject<NSCoding>*)newValue];
}

- (NSString *)valueString
{return valueLabel.text;}

- (void)setValueString:(NSString *)string
{valueLabel.text = string;}

- (void)wasSelected
{
    if (panelViewController)
    {
        UINavigationController *navController = self.parentSection.parentTable.viewController.navigationController;
        [navController pushViewController:panelViewController animated:YES];
    }
}

//=====>> Theme Getter

+ (UIImage *)editIcon
{
    if (!editIcon)editIcon = [[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFViewPanelField class]] imageForKey:THEME_KEY_EDIT_ICON];
    return editIcon;
}

//=====>> Themeable

- (void)themeChanged
{editIcon = nil;}

+ (id<AFThemeable>)themeParentSectionClass
{return (id<AFThemeable>)[AFField class];}

+ (NSString *)themeSectionName
{return nil;}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"editIcon16", THEME_KEY_EDIT_ICON,
            nil];
}

//=====>> Dealloc

- (void)dealloc
{
    [panelViewController removeObserver:self];
    [panelViewController release];
    [labelIcon release];
    [optionLabel release];
    [valueLabel release];
    [editableOptionIcon release];
    //[valueString release];
    [super dealloc];
}

@end
