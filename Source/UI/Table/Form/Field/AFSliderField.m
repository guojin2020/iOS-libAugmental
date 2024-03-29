#import "AFSliderField.h"

@implementation AFSliderField

- (id)initWithIdentity:(NSString *)identityIn
               minimum:(float)minimumIn
               maximum:(float)maximumIn
{
    self    = [super initWithIdentity:identityIn];
    minimum = minimumIn;
    maximum = maximumIn;
    return self;
}

- (NSObject <NSCoding> *)value
{return value;}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    slider = [[UISlider alloc] init];
    [self.viewCell setAccessoryView:slider];
    [self updateControlCell];
    self.viewCell.selectionStyle = UITableViewCellSelectionStyleGray;
}


- (void)updateControlCell
{if (slider)[slider setValue:[(NSNumber *) value floatValue]];}

- (void)controlValueChanged:(id)sender
{
    if (sender == slider)
    {
        value = @(minimum + ((maximum - minimum) * [slider value]));
        [super controlValueChanged:sender];
    }
}


//@dynamic validator, valid, value;

@end
