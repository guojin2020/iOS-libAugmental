
#import "AFFormSection.h"
#import "AFSettingProvider.h"
#import "AFField.h"

@implementation AFFormSection

- (id)initWithTitle:(NSString *)titleIn provider:(NSObject <AFSettingProvider> *)providerIn
{
    if ((self = [super initWithTitle:titleIn]))
    {
        provider = providerIn;
    }
    return self;
}

- (void)addField:(AFField*)field
{
	[self addCell:field];
}


@synthesize provider;

@end
