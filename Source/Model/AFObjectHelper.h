#import "AFObject.h"
#import "AFObjectViewPanelController.h"

@class AFObjectCache;
@class AFObjectHelper;
@protocol AFValidator;

@interface AFObjectHelper : NSObject
{
}

+ (void)registerObjectClass:(AFObject*)objectClass;

+ (void)deRegisterObjectClass:(AFObject*)objectClass;

+ (Class)classForModelName:(NSString *)modelNameIn;

+ (NSNumber *)numberFromString:(NSString *)string;

+ (NSURL *)URLFromString:(NSString *)string;

+ (NSURL *)URLFromString:(NSString *)string relativeToURL:(NSURL *)baseURL;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)newStringByRemovingHTML:(NSString *)stringIn;

@end
