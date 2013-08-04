#import "AFMessageCell.h"
#import "AFAssertion.h"

@implementation AFMessageCell

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    //Reassign components

    messageLabel = (UILabel *) [cell viewWithTag:1];
    [messageLabel setTextColor:[AFTableCell defaultTextColor]];

    [messageLabel setNumberOfLines:0];

    [self refreshFields];
}


- (void)refreshFields
{
    AFAssertMainThread();

    messageLabel.text = labelText;
}


@end
