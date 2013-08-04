#import "AFGenericOptionTableCell.h"
#import "UICustomDisclosureArrowView.h"
#import "AFThemeManager.h"

static UIColor *disclosureArrowColor = nil;

@implementation AFGenericOptionTableCell

+ (UIColor *)disclosureArrowColor
{
    if (!disclosureArrowColor)
    {
        disclosureArrowColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFGenericOptionTableCell class]] colorForKey:THEME_KEY_DISCLOSURE_ARROW_COLOR];
    }
    return disclosureArrowColor;
}

- (id)initWithLabelText:(NSString *)labelTextIn labelIcon:(UIImage *)labelIconIn
{
    NSAssert(labelTextIn, @"No label text parameter provided");

    if ((self = [self initWithLabelText:labelTextIn]))
    {
        labelIcon = labelIconIn;
    }
    return self;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    //Apply the default disclosure view
    UIView *arrow = [[UICustomDisclosureArrowView alloc] initWithColor:[AFGenericOptionTableCell disclosureArrowColor]];
    cell.accessoryView = arrow;

    //Reassign components

    searchOptionLabel = (UILabel *) [cell viewWithTag:1];
    searchOptionIcon  = (UIImageView *) [cell viewWithTag:2];

    //AFLog(@"%@",	searchOptionIcon);

    NSAssert(searchOptionLabel, @"");
    NSAssert(searchOptionIcon, @"");

    [searchOptionLabel setTextColor:[AFTableCell defaultTextColor]];
    [searchOptionLabel setFont:[[AFTableCell defaultTextFont] fontWithSize:[AFTableCell defaultTextSize]]];

    //AFLog(@"LabelIcon: %@",labelIcon);

    if (labelText) searchOptionLabel.text = labelText;
    if (labelIcon && [labelIcon isKindOfClass:[UIImage class]]) [searchOptionIcon setImage:labelIcon];
}

//==========>> Themeable

- (void)themeChanged
{
    disclosureArrowColor = nil;
}

+ (id<AFPThemeable>)themeParentSectionClass
{return (id<AFPThemeable>)[AFTableCell class];}

+ (NSString *)themeSectionName
{return @"genericOption";}

+ (NSDictionary *)defaultThemeSection
{
    return @{THEME_KEY_DISCLOSURE_ARROW_COLOR: @"B85430"};
}

//==========>> Dealloc


@end
