#import "AFMMYYDateSetting.h"
#import "AFThemeManager.h"
#import "AFMMYYDatePickerViewController.h"

@implementation AFMMYYDateSetting

static UIImage *dateIcon = nil;

- (id)initWithId:(NSString *)identityIn yearRange:(NSRange)rangeIn
{
    AFMMYYDatePickerViewController *datePickerViewController = [[AFMMYYDatePickerViewController alloc] initWithTitle:@"Date" observer:self yearRange:rangeIn];

    if ((self = [super initWithIdentity:identityIn
                              labelText:identityIn
                              labelIcon:[AFMMYYDateSetting dateIcon]
                    panelViewController:datePickerViewController]))
    {
        self.value = [datePickerViewController value];
    }
    [datePickerViewController release];
    return self;
}

- (void)controlValueChanged:(id)sender
{
    self.value = [(AFMMYYDatePickerViewController *) panelViewController value];
    [self updateControlCell];
}

- (void)updateControlCell
{
    [super updateControlCell];
    valueLabel.text = value ? (NSString *) value : @"Not set yet";
}

//================>> Theme Getters

+ (UIImage *)dateIcon
{
    if (!dateIcon) dateIcon = [[[AFThemeManager themeSectionForClass:[AFMMYYDateSetting class]] imageForKey:THEME_KEY_DATE_ICON] retain];
    return dateIcon;
}

//================>> Themeable

- (void)themeChanged
{
    dateIcon = nil;
}

+ (Class <AFThemeable>)themeParentSectionClass
{return [AFBaseSetting class];}

+ (NSString *)themeSectionName
{return nil;}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Date", THEME_KEY_DATE_ICON,
            nil];
}

//================>> Dealloc

- (void)dealloc
{

    [super dealloc];
}

@dynamic value, validator, valid;

@end
