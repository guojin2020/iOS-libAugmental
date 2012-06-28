
#import "AFSliderSetting.h"
#import "AFSettingPersistenceDelegate.h"

@implementation AFSliderSetting

-(id)initWithIdentity:(NSString*)identityIn
			  minimum:(float)minimumIn
			  maximum:(float)maximumIn
{
	self = [super initWithIdentity:identityIn];
	minimum = minimumIn;
	maximum = maximumIn;
	return self;
}

-(NSObject<NSCoding>*)value{return value;}

/*
-(void)setValue:(NSNumber*)valueIn
{
	NSObject<NSCoding>* oldValue = value;
	value=[valueIn retain];
	[oldValue release];
	[self updateControlCell];
}
*/
 
-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn
{
	if(!cell)
	{
		cell = [super viewCellForTableView:tableIn];
		slider = [[UISlider alloc] init];
		[cell setAccessoryView:slider];
		[self updateControlCell];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	return cell;
}

-(void)updateControlCell{if(slider)[slider setValue:[(NSNumber*)value floatValue]];}

-(void)controlValueChanged:(id)sender
{
	if(sender==slider)
	{
		value=[NSNumber numberWithFloat:minimum+((maximum-minimum)*[slider value])];
		[super controlValueChanged:sender];
	}
}

-(void)dealloc
{
	[slider release];
	[super dealloc];
}

@dynamic validator, valid,value;

@end
