
#import <UIKit/UIKit.h>

@protocol AFValidator

-(BOOL)isValid:(NSObject*)testObject;
-(NSString*)conditionDescription;

@optional
+(NSObject<AFValidator>*)sharedInstance;

@end
