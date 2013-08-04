#import "AFDatePickerViewController.h"

//#import "AFViewPanelField.h"

@implementation AFDatePickerViewController

- (id)initWithTitle:(NSString *)titleIn
{
    if ((self = [self initWithNibName:@"AFDatePickerView" bundle:[NSBundle mainBundle]]))
    {
        self.title = titleIn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (value)[picker setDate:(NSDate *) value];
    [picker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)datePickerValueChanged
{
    [self setValue:picker.date];
}

- (void)setValue:(id)valueIn
{
    if (picker && value != valueIn)[picker setDate:(NSDate *) valueIn];
    [super setValue:valueIn];
}


@synthesize picker, adviceText;

@end
