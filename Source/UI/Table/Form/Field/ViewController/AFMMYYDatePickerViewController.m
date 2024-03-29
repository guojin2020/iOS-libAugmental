#import "AFMMYYDatePickerViewController.h"
#import "AFViewPanelField.h"

@implementation AFMMYYDatePickerViewController

- (id)initWithTitle:(NSString *)titleIn
           observer:(NSObject <AFFieldViewPanelObserver> *)observerIn
          yearRange:(NSRange)range
{
    if ((self = [self initWithObserver:observerIn nibName:@"AFMMYYPicker" bundle:[NSBundle mainBundle]]))
    {
        self.title = titleIn;

        NSMutableArray *buildYearStrings = [[NSMutableArray alloc] initWithCapacity:range.length];

        NSCalendar       *gregorian       = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate           *today           = [[NSDate alloc] init];
        NSDateComponents *todayComponents = [gregorian components:NSYearCalendarUnit fromDate:today];
        int yearNumber = [todayComponents year];
        NSNumberFormatter *twoDigitFormatter = [[NSNumberFormatter alloc] init];

        [twoDigitFormatter setPositiveFormat:@"00"];

        int      end    = range.location + range.length;
        for (int offset = range.location; offset <= end; offset++)
        {
            [buildYearStrings addObject:[twoDigitFormatter stringFromNumber:@(yearNumber + offset)]];
        }

        yearStrings  = [[NSArray alloc] initWithArray:buildYearStrings];
        monthStrings = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];


        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//=============>> Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return [monthStrings count];
        case 1:
            return [yearStrings count];
        default:
            return -1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!value)
    {
        [self pickerView:picker didSelectRow:0 inComponent:0];
        [self pickerView:picker didSelectRow:0 inComponent:1];
    }
}

//=============>> Delegate

- (void)pickerView:(UIPickerView *)pickerViewIn didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSAssert(row<=1,@"DDYY Date picker had invalid component index %i selected",component);

    switch (component)
    {
        case 0:
        case 1:
            [self setValue:[NSString stringWithFormat:@"%@%@", monthStrings[(NSUInteger) [picker selectedRowInComponent:0]], yearStrings[(NSUInteger) [picker selectedRowInComponent:1]]]];
            break;
        default:
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
            return monthStrings[(NSUInteger) row];
        case 1:
            return yearStrings[(NSUInteger) row];
        default:
            return nil;
    }
}


@synthesize picker, adviceText;

@end
