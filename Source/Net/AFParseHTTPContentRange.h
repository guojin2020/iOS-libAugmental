
#import <Foundation/Foundation.h>

typedef struct AFRangeInfo
{
    NSRange    contentRange;
    NSUInteger contentTotal;
}
AFRangeInfo;

AFRangeInfo* CreateAFRangeInfoFromHTTPHeaders(NSDictionary* httpHeaders);
