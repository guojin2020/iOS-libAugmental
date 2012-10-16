#import "AFDateSetting.h"
#import "AFThemeManager.h"

@implementation AFDateSetting

static UIImage *dateIcon = nil;

- (id)initWithId:(NSString *)identityIn
{
    AFDatePickerViewController *datePickerViewController = [[AFDatePickerViewController alloc] initWithTitle:@"Date of Birth"];

    if ((self = [super initWithIdentity:identityIn
                              labelText:identityIn
                              labelIcon:[AFDateSetting dateIcon]
                    panelViewController:datePickerViewController]))
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    [datePickerViewController release];
    return self;
}

- (void)controlValueChanged:(id)sender
{
    self.value = ((AFDatePickerViewController *) panelViewController).picker.date;
    [self updateControlCell];
}

- (void)updateControlCell
{
    [super updateControlCell];
    valueLabel.text = value ? [dateFormatter stringFromDate:(NSDate *) value] : @"Not set yet";
}

//=========>> Theme Getters

+ (UIImage *)dateIcon
{
    if (!dateIcon)dateIcon = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFDateSetting class]] imageForKey:THEME_KEY_DATE_ICON] retain];
    return dateIcon;
}

//==========>> Themeable

- (void)themeChanged
{dateIcon = nil;}

+ (id<AFThemeable>)themeParentSectionClass
{return (id<AFThemeable>)[AFBaseSetting class];}

+ (NSString *)themeSectionName
{return nil;}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"", THEME_KEY_DATE_ICON,
            nil];
}

//==========>> Dealloc

- (void)dealloc
{
    [dateFormatter release];
    [super dealloc];
}

//@dynamic value, validator, valid;

@end
