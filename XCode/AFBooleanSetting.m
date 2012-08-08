
#import "AFBooleanSetting.h"
#import "AFSettingPersistenceDelegate.h"

@implementation AFBooleanSetting

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn
{
	if(!cell)
	{
		cell = [super viewCellForTableView:tableIn];
		valueSwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
		[valueSwitch addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
		[cell setAccessoryView:valueSwitch];
		[self updateControlCell];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	return cell;
}

-(void)updateControlCell
{
	[super updateControlCell];
	[valueSwitch setOn:[(NSNumber*)value boolValue] animated:NO];
}

-(void)controlValueChanged:(id)sender
{
	if(sender==valueSwitch)[self setValue:[NSNumber numberWithBool:valueSwitch.on]];
}

-(void)dealloc
{
	[valueSwitch release];
	[super dealloc];
}

@dynamic value, validator, valid;

@end
