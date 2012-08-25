#import <Foundation/Foundation.h>
#import "AFTableSection.h"

@class AFTableCell;
@protocol AFSettingsProvider;
@protocol AFSetting;

@interface AFSettingsSection : AFTableSection
{
    NSString                      *name;
    NSObject <AFSettingsProvider> *provider;
}

- (id)initWithTitle:(NSString *)title provider:(NSObject <AFSettingsProvider> *)providerIn;

- (void)addSetting:(AFTableCell <AFSetting> *)setting;

@property(nonatomic, retain) NSObject <AFSettingsProvider> *provider;

@end
