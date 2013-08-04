#import "AFPickerViewController.h"
#import "AFThemeManager.h"

static UIColor *textColor = nil;
static UIColor *bgColor   = nil;

@implementation AFPickerViewController

- (id)initWithObjects:(NSArray *)objectsIn
             delegate:(NSObject <AFObjectPickerDelegate> *)delegateIn
                title:(NSString *)titleIn
{
    if ((self = [super initWithNibName:@"AFSimpleObjectPicker" bundle:[NSBundle mainBundle]]))
    {
        self.objects = objectsIn;
        self.title   = titleIn;
        delegate = delegateIn;

        defaultValue = nil;
        value        = nil;
    }
    return self;
}

- (void)setObjects:(NSArray *)objectsIn
{
    NSArray *oldObjects = objects;
    objects = [[NSMutableArray alloc] initWithArray:objectsIn];
    if ((!defaultValue || ![objects containsObject:defaultValue]) && [objects count] > 0) self.defaultValue = objects[0];
}

- (void)setValue:(id)valueIn
{
    if (picker && value != valueIn)
    {
        if (![objects containsObject:(NSObject *) valueIn])
        {
            self.objects = [objects arrayByAddingObject:valueIn];
            [picker reloadAllComponents];
        }
        [picker selectRow:[objects indexOfObject:valueIn] inComponent:0 animated:NO];
    }
    [super setValue:valueIn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //if(!value && defaultValue) value=defaultValue;
    [picker reloadAllComponents];
    int index = [objects indexOfObject:value];
    if (value)[picker selectRow:index inComponent:0 animated:NO];

    [self.view setBackgroundColor:[AFPickerViewController bgColor]];
    [adviceText setTextColor:[AFPickerViewController textColor]];
}

//=============>> Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{return 1;}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{return component == 0 ? [objects count] : 0;}

//=============>> Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component != 0 || row < 0 || row > [self pickerView:pickerView numberOfRowsInComponent:0])
    {
        return;
    }
    else
    {
        self.value = objects[(NSUInteger) row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *objectTitle = component == 0 ? [delegate titleForObject:objects[(NSUInteger) row]] : nil;
    return objectTitle;
}

//================>> Theme Getters

+ (UIColor *)textColor
{
    if (!textColor)
    {textColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFPickerViewController class]] colorForKey:THEME_KEY_TEXT_COLOR];}
    return textColor;
}

+ (UIColor *)bgColor
{
    if (!bgColor)
    {bgColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFPickerViewController class]] colorForKey:THEME_KEY_BG_COLOR];}
    return bgColor;
}

//================>> Themeable

- (void)themeChanged
{
    textColor = nil;
    bgColor   = nil;
}

+ (id<AFPThemeable>)themeParentSectionClass
{return nil;}

+ (NSString *)themeSectionName
{return @"picker";}

+ (NSDictionary *)defaultThemeSection
{
    return @{THEME_KEY_TEXT_COLOR: @"000000",
            THEME_KEY_BG_COLOR: @"FFFFFF"};
}

//================>> Dealloc


@synthesize picker, adviceText, objects;

@end
