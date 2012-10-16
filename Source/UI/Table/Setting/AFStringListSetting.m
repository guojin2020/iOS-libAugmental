#import "AFStringListSetting.h"

@implementation AFStringListSetting

- (id)initWithIdentity:(NSString *)identityIn
                 title:(NSString *)titleIn
            stringList:(NSArray *)stringListIn
             labelIcon:(UIImage *)icon
{
    AFStringListPickerViewController *stringPickerViewController = [[AFStringListPickerViewController alloc] initWithStrings:stringListIn title:titleIn];

    if ((self = [super initWithIdentity:identityIn
                              labelText:@"Checkout style"
                              labelIcon:icon
                    panelViewController:stringPickerViewController]))
    {
    }

    [stringPickerViewController release];
    return self;
}

- (void)updateControlCell
{
    valueLabel.text = (NSString *) (panelViewController.value);
    [super updateControlCell];
}

//@dynamic valid, validator, value;

@end
