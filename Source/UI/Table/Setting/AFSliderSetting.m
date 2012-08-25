#import "AFSliderSetting.h"

@implementation AFSliderSetting

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
    [cell setAccessoryView:slider];
    [self updateControlCell];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
}


- (void)updateControlCell
{if (slider)[slider setValue:[(NSNumber *) value floatValue]];}

- (void)controlValueChanged:(id)sender
{
    if (sender == slider)
    {
        value = [NSNumber numberWithFloat:minimum + ((maximum - minimum) * [slider value])];
        [super controlValueChanged:sender];
    }
}

- (void)dealloc
{
    [slider release];
    [super dealloc];
}

@dynamic validator, valid, value;

@end
