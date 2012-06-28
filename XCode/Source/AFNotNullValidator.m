
#import "AFNotNullValidator.h"

static AFNotNullValidator* sharedInstance = nil;

@implementation AFNotNullValidator

+(NSObject<AFValidator>*)sharedInstance
{
	if(!sharedInstance) sharedInstance = [[AFNotNullValidator alloc] init];
	return sharedInstance;
}

-(BOOL)isValid:(NSObject*)testObject{return testObject!=nil;}
-(NSString*)conditionDescription{return @"be set.";}

@end
