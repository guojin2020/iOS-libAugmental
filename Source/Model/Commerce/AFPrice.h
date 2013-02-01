//
// Created by augmental on 31/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@interface AFPrice : NSObject

@property (nonatomic, retain) NSNumber* price;
@property (nonatomic, retain) NSLocale* priceLocale;

-(id)initWithPrice:(NSNumber *)priceIn priceLocale:(NSLocale *)priceLocaleIn;

-(NSString*)string;

@end