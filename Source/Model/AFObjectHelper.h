#import "AFObject.h"
#import "AFObjectViewPanelController.h"

@class AFLegacyObjectCache;
@class AFObjectHelper;
@protocol AFValidator;

@interface AFObjectHelper : NSObject
{
}

+ (void)registerObjectClass:(id<AFObject>)objectClass;

+ (void)deRegisterObjectClass:(id<AFObject>)objectClass;

+ (id<AFObject>)classForModelName:(NSString *)modelNameIn;

+ (NSNumber *)numberFromString:(NSString *)string;

+ (NSURL *)URLFromString:(NSString *)string;

+ (NSURL *)URLFromString:(NSString *)string relativeToURL:(NSURL *)baseURL;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)newStringByRemovingHTML:(NSString *)stringIn;

@end
