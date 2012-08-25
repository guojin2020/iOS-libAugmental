#import <Foundation/Foundation.h>

#import "AFThemeable.h"
#import "AFThemeObserver.h"

@protocol AFThemeable <NSObject, AFThemeObserver>

+ (Class <AFThemeable>)themeParentSectionClass;

+ (NSString *)themeSectionName;

+ (NSDictionary *)defaultThemeSection;

@end
