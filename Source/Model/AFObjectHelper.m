#import "AFObjectViewPanelController.h"

#import "AFObjectHelper.h"

@implementation AFObjectHelper

static const NSNumberFormatter *numberFormatter;
static const NSDateFormatter   *dateFormatter;
static const AFObjectHelper    *instance;
static const NSMutableSet      *objectClasses;
static const NSDictionary      *tidyHTMLReplacements;

+ (void)initialize
{
    instance      = [[AFObjectHelper alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd 00:00:00"];
    numberFormatter = [[NSNumberFormatter alloc] init];

    tidyHTMLReplacements = [[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@":", @"'", @"\"", @"'", @"\n", @"\"", @"\"", @"\n- ", nil]
                                                        forKeys:[NSArray arrayWithObjects:@"<br>", @"&#39", @"&quot;", @"&rsquo;", @"<br />", @"&ldquo;", @"&rdquo;", @"&bull;", nil]] retain];
}

+ (void)registerObjectClass:(id<AFObject>)objectClass
{
    if (!objectClasses) objectClasses = [[NSMutableSet alloc] init];
    [objectClasses addObject:objectClass];
}

+ (void)deRegisterObjectClass:(id<AFObject>)objectClass
{
    [objectClasses removeObject:objectClass];
}

+ (id<AFObject>)classForModelName:(NSString *)modelNameIn
{
    for (id<AFObject> curClass in objectClasses)
    {
        if ([[curClass modelName] isEqualToString:modelNameIn]) return curClass;
    }
    return nil;
}

+ (NSNumber *)numberFromString:(NSString *)string
{return !string || (id)string == [NSNull null] ? nil : [numberFormatter numberFromString:string];}

+ (NSDate *)dateFromString:(NSString *)string
{
    return !string || (id)string == [NSNull null] ? nil : [dateFormatter dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return [dateFormatter stringFromDate:date];
}

+ (NSURL *)URLFromString:(NSString *)string
{
    if (!string || (id)string == [NSNull null]) return nil;
    else return [NSURL URLWithString:string];
}

+ (NSURL *)URLFromString:(NSString *)string relativeToURL:(NSURL *)baseURL
{
    if (!string || !baseURL || (id)string == [NSNull null]) return nil;
    else return [NSURL URLWithString:string relativeToURL:baseURL];
}

+ (NSString *)newStringByRemovingHTML:(NSString *)string
{
    return string;
    /*
     if(![string isKindOfClass:[NSString class]]) return nil;

     //NSString* oldString;
     for(NSString* badString in [tidyHTMLReplacements allKeys])
     {
         string = [[string stringByReplacingOccurrencesOfString:badString withString:[tidyHTMLReplacements valueForKey:badString]] retain];
     }
     return string;
      */
}


- (void)dealloc
{
    [objectClasses release];
    [super dealloc];
}

@end
