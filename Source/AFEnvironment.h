
#import <Foundation/Foundation.h>

/* DEPRECATED_ATTRIBUTE */
@interface AFEnvironment : NSObject
{
	NSURL* APIBaseURL;
	NSURL* productImageBaseURL;
	NSURL* paypalNotificationURL;
}

-(id)initWithAPI:(NSURL*)APIBaseURLIn productImageBaseURL:(NSURL*)productImageBaseURLIn paypalNotificationURL:(NSURL*)paypalNotificationURL;

+(AFEnvironment*)liveEnvironment;
+(AFEnvironment*)devEnvironment;

@property (nonatomic,retain,readonly) NSURL* APIBaseURL;
@property (nonatomic,retain,readonly) NSURL* productImageBaseURL;
@property (nonatomic,retain,readonly) NSURL* paypalNotificationURL;

@end
