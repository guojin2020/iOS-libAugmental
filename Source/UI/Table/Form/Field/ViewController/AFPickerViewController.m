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
        delegate = [delegateIn retain];

        defaultValue = nil;
        value        = nil;
    }
    return self;
}

- (void)setObjects:(NSArray *)objectsIn
{
    NSArray *oldObjects = objects;
    objects = [[NSMutableArray alloc] initWithArray:objectsIn];
    [oldObjects release];
    if ((!defaultValue || ![objects containsObject:defaultValue]) && [objects count] > 0) self.defaultValue = [objects objectAtIndex:0];
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
        self.value = [objects objectAtIndex:(NSUInteger) row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *objectTitle = component == 0 ? [delegate titleForObject:[objects objectAtIndex:(NSUInteger) row]] : nil;
    return objectTitle;
}

//================>> Theme Getters

+ (UIColor *)textColor
{
    if (!textColor)
    {textColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFPickerViewController class]] colorForKey:THEME_KEY_TEXT_COLOR] retain];}
    return textColor;
}

+ (UIColor *)bgColor
{
    if (!bgColor)
    {bgColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFPickerViewController class]] colorForKey:THEME_KEY_BG_COLOR] retain];}
    return bgColor;
}

//================>> Themeable

- (void)themeChanged
{
    textColor = nil;
    bgColor   = nil;
}

+ (id<AFThemeable>)themeParentSectionClass
{return nil;}

+ (NSString *)themeSectionName
{return @"picker";}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"000000", THEME_KEY_TEXT_COLOR,
            @"FFFFFF", THEME_KEY_BG_COLOR,
            nil];
}

//================>> Dealloc

- (void)dealloc
{
    //[setting release];
    [objects release];
    [delegate release];
    [picker release];
    [adviceText release];
    [super dealloc];
}

@synthesize picker, adviceText, objects;

@end
