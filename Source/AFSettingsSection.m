
#import "AFSettingsSection.h"
#import "AFTableCell.h"
#import "AFSettingsProvider.h"
#import "AFSetting.h"

@implementation AFSettingsSection

-(id)initWithTitle:(NSString*)titleIn provider:(NSObject<AFSettingsProvider>*)providerIn
{
	if((self = [super initWithTitle:titleIn]))
	{
		provider = [providerIn retain];
	}
	return self;
}

-(void)addSetting:(AFTableCell<AFSetting>*)setting
{
	[self addCell:setting];
}

-(void)dealloc
{
	[provider release];
	[super dealloc];
}

@synthesize provider;

@end
