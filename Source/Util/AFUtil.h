#import <Foundation/Foundation.h>

@interface AFUtil : NSObject
{
}

+ (NSString *)priceStringFromFloat:(float)priceFloat;

+ (NSString *)weightStringFromFloat:(float)weightFloat;

+ (void)displayInfoWithTitle:(NSString *)title message:(NSString *)message;

+ (void)logViewSize:(UIView *)view withName:(NSString *)name;

+ (void)dumpDictionary:(NSDictionary *)dictionary;

+ (BOOL)connectedToNetwork;

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;

+ (NSArray *)allocIdArrayFromCsv:(NSString *)csvIdList;

+ (NSString *)allocCsvIdListFromObjectArray:(NSArray *)objects;

+ (BOOL)isIPad;

+ (BOOL)is32OrLater;

+ (NSString *)newDurationString:(NSTimeInterval)seconds;

+ (void)logData:(NSData *)data;

@end
