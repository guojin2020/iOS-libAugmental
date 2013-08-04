#import "AFMMYYDateField.h"
#import "AFThemeManager.h"
#import "AFMMYYDatePickerViewController.h"

@implementation AFMMYYDateField

static UIImage *dateIcon = nil;

- (id)initWithId:(NSString *)identityIn yearRange:(NSRange)rangeIn
{
    AFMMYYDatePickerViewController *datePickerViewController = [[AFMMYYDatePickerViewController alloc] initWithTitle:@"Date" observer:self yearRange:rangeIn];

    if ((self = [super initWithIdentity:identityIn
                              labelText:identityIn
                              labelIcon:[AFMMYYDateField dateIcon]
                    panelViewController:datePickerViewController]))
    {
        self.value = [datePickerViewController value];
    }
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
    if (!dateIcon) dateIcon = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFMMYYDateField class]] imageForKey:THEME_KEY_DATE_ICON];
    return dateIcon;
}

//================>> Themeable

- (void)themeChanged
{
    dateIcon = nil;
}

+ (id<AFPThemeable>)themeParentSectionClass
{return (id<AFPThemeable>)[AFField class];}

+ (NSString *)themeSectionName
{return nil;}

+ (NSDictionary *)defaultThemeSection
{
    return @{THEME_KEY_DATE_ICON: @"Date"};
}

//================>> Dealloc


//@dynamic value, validator, valid;

@end
