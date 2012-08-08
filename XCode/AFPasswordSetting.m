
#import "AFPasswordSetting.h"
#import "AFPasswordValidator.h"

@implementation AFPasswordSetting

-(id)initWithIdentity:(NSString *)identityIn
		  allowsEmpty:(BOOL)allowsEmptyIn
{
	if((self = [super initWithIdentity:identityIn]))
	{
		[self.validator = [[AFPasswordValidator alloc] initWithComparisonSetting:nil allowsEmpty:allowsEmptyIn] release];
	}
	return self;
}

-(UITableViewCell*)viewCellForTableView:(UITableView*)tableIn
{
	if(!cell)
	{		
		cell=[super viewCellForTableView:tableIn];
		textField.secureTextEntry = YES;
	}
	return cell;
}

-(void)setValue:(NSObject<NSCoding>*)valueIn
{
	[super setValue:valueIn];
	[counterpart counterpartUpdated];
}

-(void)counterpartUpdated
{
	valueChangedSinceLastValidation = YES;
	[self updateControlCell];
}

-(void)setCounterpart:(AFPasswordSetting *)counterpartIn
{
	AFPasswordSetting* oldCounterpart = counterpart;
	counterpart = [counterpartIn retain];
	[oldCounterpart release];
	
	((AFPasswordValidator*)self.validator).comparisonSetting = counterpart;
}

- (void)dealloc {
    [counterpart release];
    [counterpart release];
    [super dealloc];
}

@synthesize counterpart;

@end
