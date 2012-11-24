#import "AFFormSection.h"
#import "AFSettingProvider.h"
#import "AFField.h"

@implementation AFFormSection

- (id)initWithTitle:(NSString *)titleIn provider:(NSObject <AFSettingProvider> *)providerIn
{
    if ((self = [super initWithTitle:titleIn]))
    {
        provider = [providerIn retain];
    }
    return self;
}

- (void)addField:(AFTableCell <AFField> *)field
{
	[self addCell:field];
}

- (void)dealloc
{
    [provider release];
    [super dealloc];
}

@synthesize provider;

@end
