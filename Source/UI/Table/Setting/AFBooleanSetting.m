#import "AFBooleanSetting.h"

@implementation AFBooleanSetting

- (void)updateControlCell
{
    [super updateControlCell];
    [valueSwitch setOn:[(NSNumber *) value boolValue] animated:NO];
}

- (void)controlValueChanged:(id)sender
{
    if (sender == valueSwitch)[self setValue:[NSNumber numberWithBool:valueSwitch.on]];
}

- (void)dealloc
{
    [valueSwitch release];
    [super dealloc];
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    valueSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [valueSwitch addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [cell setAccessoryView:valueSwitch];
    [self updateControlCell];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}

@dynamic value, validator, valid;

@end
