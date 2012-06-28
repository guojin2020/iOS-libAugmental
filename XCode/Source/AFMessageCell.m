
#import "AFMessageCell.h"
#import "AFCellViewFactory.h"

@implementation AFMessageCell

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn;
{
	if(!cell||tableView!=tableIn)
	{
		self.cell = [super viewCellForTableView:tableIn templateName:@"messageCell"];
		
		//Reassign components
		[messageLabel release];
		
		messageLabel = [(UILabel*)[cell viewWithTag:1] retain];
		[messageLabel setTextColor:[AFTableCell defaultTextColor]];
		
		[messageLabel setNumberOfLines:0];
		
		[self refreshFields];
	}
	return cell;
}

-(void)refreshFields
{
	messageLabel.text = labelText;
}

@end
