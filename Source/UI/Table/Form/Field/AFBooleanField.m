#import "AFBooleanField.h"

@implementation AFBooleanField

- (void)updateControlCell
{
    [super updateControlCell];
    [valueSwitch setOn:[(NSNumber *)self.value boolValue] animated:NO];
}

- (void)controlValueChanged:(id)sender
{
    if (sender == valueSwitch)[self setValue:[NSNumber numberWithBool:valueSwitch.on]];
}


- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    valueSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [valueSwitch addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.viewCell setAccessoryView:valueSwitch];
    [self updateControlCell];
    self.viewCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//@dynamic value, validator, valid;

@end
