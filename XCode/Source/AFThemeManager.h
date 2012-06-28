
#import <Foundation/Foundation.h>

#define DEFAULT_THEME_NAME @"defaultTheme"

@protocol AFThemeable;
@protocol AFThemeObserver;

@interface AFThemeManager : NSObject{}

+(void)addObserver:(NSObject<AFThemeObserver>*)observerIn;
+(void)removeObserver:(NSObject<AFThemeObserver>*)observerIn;

+(void)setCurrentTheme:(NSDictionary*)newTheme;

+(NSDictionary*)themeSectionForClass:(Class<AFThemeable>)themeableClass;

+(NSDictionary*)generateThemeTemplate;
+(NSMutableSet*)newSetOfThemeableClasses;

+(NSDictionary*)currentTheme;

@property (nonatomic, retain) NSDictionary* currentTheme;

@end

//=========>> Convenience methods on NSDictionary for dealing with themes

@interface NSDictionary (AFTheme)

-(BOOL)boolForKey:(NSString*)key;
-(UIColor*)colorForKey:(NSString*)key;
-(BOOL)floatForKey:(NSString*)key;
-(UIImage*)imageForKey:(NSString*)key;

@end

@interface UIColor (AFTheme)

- (CGColorSpaceModel)colorSpaceModel;
- (NSString*)colorSpaceString;
- (BOOL)canProvideRGBComponents;
- (CGFloat)red;
- (CGFloat)green;
- (CGFloat)blue;
- (CGFloat)alpha;

-(NSString*)stringFromColor;
-(NSString*)hexStringFromColor;

- (NSString*)stringFromColor;
- (NSString*)hexStringFromColor;
+ (UIColor*)colorWithString: (NSString *) stringToConvert;
+ (UIColor*)colorWithHexString: (NSString *) stringToConvert;

@end
