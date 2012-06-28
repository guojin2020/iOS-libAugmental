
#import "AFStringNotEmptyValidator.h"

static AFStringNotEmptyValidator* sharedInstance = nil;

@implementation AFStringNotEmptyValidator

+(NSObject<AFValidator>*)sharedInstance
{
	if(!sharedInstance) sharedInstance = [[AFStringNotEmptyValidator alloc] init];
	return sharedInstance;
}

-(BOOL)isValid:(NSObject*)testObject{return [((NSString*)testObject) length]>0;}
-(NSString*)conditionDescription{return @"not be empty.";}

@end
