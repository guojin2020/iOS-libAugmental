//
// Created by Chris Hatton on 04/05/2013.
//
#import "NSNumber+Ordinal.h"

@implementation NSNumber (Ordinal)

-(NSString*)ordinalString
{
	NSString *ending;

	NSInteger value = [self integerValue];
	int ones = [self intValue] % 10;
	int tens = floor(value / 10);
	tens = tens % 10;
	if(tens == 1){
		ending = @"th";
	}else {
		switch (ones) {
			case 1:
				ending = @"st";
		        break;
			case 2:
				ending = @"nd";
		        break;
			case 3:
				ending = @"rd";
		        break;
			default:
				ending = @"th";
		        break;
		}
	}
	return [NSString stringWithFormat:@"%d%@", value, ending];
}

@end