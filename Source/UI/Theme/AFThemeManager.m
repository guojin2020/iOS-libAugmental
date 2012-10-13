#import "AFThemeManager.h"
#import "AFThemeObserver.h"
#import "AFThemeable.h"
#import "AFImageCache.h"
#import <objc/runtime.h>

#define ROOT_DICTIONARY_CACHE_KEY @"ROOT"

@interface AFThemeManager ()

+ (NSMutableDictionary *)composeThemeForClass:(id<AFThemeable>)themeableClass usingCache:(NSMutableDictionary *)themeCache;

@end

@implementation AFThemeManager

static NSDictionary *currentTheme;
static UIColor      *DEFAULT_VOID_COLOR = nil;
static NSMutableSet *observers;

+ (void)initialize
{
    DEFAULT_VOID_COLOR = [[UIColor clearColor] retain];
    observers          = [[NSMutableSet alloc] init];
}

+ (NSDictionary *)currentTheme
{
    if (!currentTheme)
    {
        currentTheme = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:DEFAULT_THEME_NAME ofType:@"plist"]];

        //NSLog(@"Loaded theme with %i sections...\n%@",[currentTheme count],currentTheme);

    }
    return currentTheme;
}

+ (void)addObserver:(NSObject <AFThemeObserver> *)observerIn
{[observers addObject:observerIn];}

+ (void)removeObserver:(NSObject <AFThemeObserver> *)observerIn
{[observers removeObject:observerIn];}

+ (NSDictionary *)newThemeTemplate
{
    NSMutableSet        *themeables          = [AFThemeManager newSetOfThemeableClasses];
    NSMutableDictionary *rootThemeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *themeCache          = [[NSMutableDictionary alloc] init];
    [themeCache setObject:rootThemeDictionary forKey:ROOT_DICTIONARY_CACHE_KEY];
    id<AFThemeable> currentClass;

    while ([themeables count] > 0)
    {
        currentClass = [themeables anyObject];
        //NSLog(@"Composing dictionary for %@...",NSStringFromClass(currentClass));
        [themeables removeObject:currentClass];
        [AFThemeManager composeThemeForClass:currentClass usingCache:themeCache];
    }

    [themeCache release];
    [themeables release];

    return rootThemeDictionary;
}

+ (NSMutableDictionary *)composeThemeForClass:(id<AFThemeable>)themeableClass usingCache:(NSMutableDictionary *)themeCache
{
    NSString            *className  = NSStringFromClass(themeableClass);
    NSMutableDictionary *dictionary = [themeCache objectForKey:className];
    if (!dictionary)
    {
        id<AFThemeable> parentClass = [themeableClass themeParentSectionClass];
        NSMutableDictionary *parentDictionary = parentClass ? [self composeThemeForClass:parentClass usingCache:themeCache] : [themeCache objectForKey:ROOT_DICTIONARY_CACHE_KEY];

        NSString *classSectionName = [themeableClass themeSectionName];
        if (classSectionName) //If this has it's own section, create a new dictionary for it and fill with default contents
        {
            NSMutableDictionary *existingDictionary = [parentDictionary objectForKey:classSectionName];
            if (existingDictionary)
            {
                dictionary = existingDictionary;
                [dictionary addEntriesFromDictionary:[themeableClass defaultThemeSection]];
            }
            else
            {
                dictionary = [[NSMutableDictionary alloc] initWithDictionary:[themeableClass defaultThemeSection]];
                [parentDictionary setObject:dictionary forKey:classSectionName];
                [dictionary release];
            }
        }
        else
        {
            dictionary = parentDictionary;
            [dictionary addEntriesFromDictionary:[themeableClass defaultThemeSection]];
        }
    }

    [themeCache setObject:dictionary forKey:className];

    return dictionary;
}

+ (NSMutableSet *)newSetOfThemeableClasses
{
    NSMutableSet *themeableClasses = [[NSMutableSet alloc] init];
    int numClasses = objc_getClassList(NULL, 0);

    if (numClasses > 0)
    {
        Class *classes = NULL;
        Class class;

        classes = malloc(sizeof(Class) * numClasses);
        objc_getClassList(classes, numClasses);

        for (int i = 0; i < numClasses; i++)
        {
            class = classes[i];
            if ([NSStringFromClass(class) hasPrefix:@"AF"] && [class conformsToProtocol:@protocol(AFThemeable)])[themeableClasses addObject:class];
        }
        //NSLog(@"...finished.");
        free(classes);
    }

    return themeableClasses;
}

+ (void)setCurrentTheme:(NSDictionary *)newTheme
{
    NSDictionary *oldTheme = currentTheme;
    currentTheme = [newTheme retain];
    [oldTheme release];

    for (NSObject <AFThemeObserver> *observer in observers)
    {[observer themeChanged];}
}

+ (NSDictionary *)themeSectionForClass:(id<AFThemeable>)themeableClass
{
    //NSLog(@"%@",NSStringFromClass(themeableClass));
    id<AFThemeable> themeableParentClass = [themeableClass themeParentSectionClass];
    NSDictionary *parentSection    = themeableParentClass ? [self themeSectionForClass:themeableParentClass] : [AFThemeManager currentTheme];
    NSString     *themeSectionName = [themeableClass themeSectionName];
    return themeSectionName ? [parentSection objectForKey:themeSectionName] : parentSection;
}

+ (AFThemeManager *)sharedInstance
{
    return nil;
}


@end

//=========>> Convenience categories for dealing with themes

@implementation NSDictionary (AFTheme)

- (BOOL)boolForKey:(NSString *)key
{return [(NSNumber *) [self valueForKey:key] boolValue];}

- (BOOL)floatForKey:(NSString *)key
{return [(NSNumber *) [self valueForKey:key] floatValue];}

- (UIColor *)colorForKey:(NSString *)key
{return [UIColor colorWithHexString:[self valueForKey:key]];}

- (UIImage *)imageForKey:(NSString *)key
{return [AFImageCache image:[self valueForKey:key]];}

@end

@implementation UIColor (AFTheme)

- (CGColorSpaceModel)colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}

- (NSString *)colorSpaceString
{
    switch ([self colorSpaceModel])
    {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
        default:
            return @"Not a valid color space";
    }
}

- (BOOL)canProvideRGBComponents
{
    return (([self colorSpaceModel] == kCGColorSpaceModelRGB) ||
            ([self colorSpaceModel] == kCGColorSpaceModelMonochrome));
}

- (CGFloat)red
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[0];
}

- (CGFloat)green
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[1];
}

- (CGFloat)blue
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use -red, -green, -blue");
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    if ([self colorSpaceModel] == kCGColorSpaceModelMonochrome) return c[0];
    return c[2];
}

- (CGFloat)alpha
{
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    return c[CGColorGetNumberOfComponents(self.CGColor) - 1];
}

- (NSString *)stringFromColor
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use stringFromColor");
    return [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", self.red, self.green, self.blue, self.alpha];
}

- (NSString *)hexStringFromColor
{
    NSAssert (self.canProvideRGBComponents, @"Must be a RGB color to use hexStringFromColor");

    CGFloat r, g, b;
    r = self.red;
    g = self.green;
    b = self.blue;

    // Fix range if needed
    if (r < 0.0f) r = 0.0f;
    if (g < 0.0f) g = 0.0f;
    if (b < 0.0f) b = 0.0f;

    if (r > 1.0f) r = 1.0f;
    if (g > 1.0f) g = 1.0f;
    if (b > 1.0f) b = 1.0f;

    // Convert to hex string between 0x00 and 0xFF
    return [NSString stringWithFormat:@"%02X%02X%02X",
                                      (int) (r * 255), (int) (g * 255), (int) (b * 255)];
}

+ (UIColor *)colorWithString:(NSString *)stringToConvert
{
    NSString *cString = [stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // Proper color strings are denoted with braces
    if (![cString hasPrefix:@"{"]) return DEFAULT_VOID_COLOR;
    if (![cString hasSuffix:@"}"]) return DEFAULT_VOID_COLOR;

    // Remove braces
    cString = [cString substringFromIndex:1];
    cString = [cString substringToIndex:([cString length] - 1)];
    CFShow(cString);

    // Separate into components by removing commas and spaces
    NSArray *components = [cString componentsSeparatedByString:@", "];
    if ([components count] != 4) return DEFAULT_VOID_COLOR;

    // Create the color
    return [UIColor colorWithRed:[[components objectAtIndex:0] floatValue]
                           green:[[components objectAtIndex:1] floatValue]
                            blue:[[components objectAtIndex:2] floatValue]
                           alpha:[[components objectAtIndex:3] floatValue]];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

    if ([cString length] != 6) return DEFAULT_VOID_COLOR;

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length   = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
