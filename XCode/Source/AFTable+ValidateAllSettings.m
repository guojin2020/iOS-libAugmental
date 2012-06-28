
#import "AFTable+ValidateAllSettings.h"
#import "AFTableCell.h"
#import "AFSetting.h"
#import "AFValidator.h"

@implementation AFTable (ValidatableBySettings)

-(BOOL)valid{return [self validateWithInvalidUserAlert];}

-(BOOL)validateWithInvalidUserAlert
{
	NSMutableString* errorMessage = [[NSMutableString alloc] init];
	for(AFTableSection* section in self)
	{
		for(AFTableCell* cell in section)
		{
			if([cell conformsToProtocol:@protocol(AFSetting)] && ((NSObject<AFSetting>*)cell).validator && !((NSObject<AFSetting>*)cell).valid)
			{
				[errorMessage appendString:[((NSObject<AFSetting>*)cell) identity]];
				[errorMessage appendString:@" must "];
				[errorMessage appendString:[((NSObject<AFSetting>*)cell).validator conditionDescription]];
				[errorMessage appendString:@"\n"];
			}
		}
	}
	
	BOOL returnVal;
	if([errorMessage length]>0)
	{
		UIAlertView* rejectAlert = [[UIAlertView alloc] initWithTitle:@"Please correct the following" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[rejectAlert show];
		[rejectAlert release];
		returnVal = NO;
	}
	else returnVal = YES;
	[errorMessage release];
	return returnVal;
}

@end
