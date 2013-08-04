
#import "AFTable+ValidateAllSettings.h"
#import "AFTableCell.h"
#import "AFField.h"
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
			if([cell isKindOfClass:[AFField class]] && ((AFField*)cell).validator && !((AFField*)cell).valid)
			{
				[errorMessage appendString:[((AFField*)cell) identity]];
				[errorMessage appendString:@" must "];
				[errorMessage appendString:[((AFField*)cell).validator conditionDescription]];
				[errorMessage appendString:@"\n"];
			}
		}
	}
	
	BOOL returnVal;
	if([errorMessage length]>0)
	{
		UIAlertView* rejectAlert = [[UIAlertView alloc] initWithTitle:@"Please correct the following" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[rejectAlert show];
		returnVal = NO;
	}
	else returnVal = YES;
	return returnVal;
}

@end
