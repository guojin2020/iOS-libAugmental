
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

@property (nonatomic,strong,readonly) NSURL* APIBaseURL;
@property (nonatomic,strong,readonly) NSURL* productImageBaseURL;
@property (nonatomic,strong,readonly) NSURL* paypalNotificationURL;

@end
