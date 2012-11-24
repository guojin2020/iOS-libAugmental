#import "AFGenericOptionTableCell.h"
#import "UICustomDisclosureArrowView.h"
#import "AFThemeManager.h"

static UIColor *disclosureArrowColor = nil;

@implementation AFGenericOptionTableCell

+ (UIColor *)disclosureArrowColor
{
    if (!disclosureArrowColor)
    {
        disclosureArrowColor = [[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFGenericOptionTableCell class]] colorForKey:THEME_KEY_DISCLOSURE_ARROW_COLOR];
    }
    return disclosureArrowColor;
}

- (id)initWithLabelText:(NSString *)labelTextIn labelIcon:(UIImage *)labelIconIn
{
    NSAssert(labelTextIn, @"No label text parameter provided");

    if ((self = [self initWithLabelText:labelTextIn]))
    {
        labelIcon = [labelIconIn retain];
    }
    return self;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    //Apply the default disclosure view
    UIView *arrow = [[UICustomDisclosureArrowView alloc] initWithColor:[AFGenericOptionTableCell disclosureArrowColor]];
    cell.accessoryView = arrow;
    [arrow release];

    //Reassign components
    [searchOptionLabel release];
    [searchOptionIcon release];

    searchOptionLabel = [(UILabel *) [cell viewWithTag:1] retain];
    searchOptionIcon  = [(UIImageView *) [cell viewWithTag:2] retain];

    //NSLog(@"%@",	searchOptionIcon);

    NSAssert(searchOptionLabel, @"");
    NSAssert(searchOptionIcon, @"");

    [searchOptionLabel setTextColor:[AFTableCell defaultTextColor]];
    [searchOptionLabel setFont:[[AFTableCell defaultTextFont] fontWithSize:[AFTableCell defaultTextSize]]];

    //NSLog(@"LabelIcon: %@",labelIcon);

    if (labelText) searchOptionLabel.text = labelText;
    if (labelIcon && [labelIcon isKindOfClass:[UIImage class]]) [searchOptionIcon setImage:labelIcon];
}

//==========>> Themeable

- (void)themeChanged
{
    disclosureArrowColor = nil;
}

+ (id<AFThemeable>)themeParentSectionClass
{return (id<AFThemeable>)[AFTableCell class];}

+ (NSString *)themeSectionName
{return @"genericOption";}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"B85430", THEME_KEY_DISCLOSURE_ARROW_COLOR, nil];
}

//==========>> Dealloc

- (void)dealloc
{
    [labelIcon release];
    [searchOptionLabel release];
    [searchOptionIcon release];
    [super dealloc];
}

@end
