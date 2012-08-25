#import "AFMessageCell.h"

@implementation AFMessageCell

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    //Reassign components
    [messageLabel release];

    messageLabel = [(UILabel *) [cell viewWithTag:1] retain];
    [messageLabel setTextColor:[AFTableCell defaultTextColor]];

    [messageLabel setNumberOfLines:0];

    [self refreshFields];
}


- (void)refreshFields
{
    messageLabel.text = labelText;
}

- (void)dealloc
{
    [messageLabel release];
    [super dealloc];
}

@end
