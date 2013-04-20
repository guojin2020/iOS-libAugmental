#import <Foundation/Foundation.h>

#import "AFPThemeable.h"
#import "AFThemeObserver.h"

@protocol AFPThemeable <NSObject, AFThemeObserver>

+ (id<AFPThemeable>)themeParentSectionClass;

+ (NSString *)themeSectionName;

+ (NSDictionary *)defaultThemeSection;

@end
