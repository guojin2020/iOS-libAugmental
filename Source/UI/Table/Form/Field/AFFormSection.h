#import <Foundation/Foundation.h>
#import "AFTableSection.h"

@class      AFTableCell;
@protocol   AFSettingProvider;
@protocol   AFField;

@interface AFFormSection : AFTableSection
{
    NSString                      *name;
    NSObject <AFSettingProvider> *provider;
}

- (id)initWithTitle:(NSString *)title provider:(NSObject <AFSettingProvider> *)providerIn;

- (void)addField:(AFTableCell <AFField> *)field;

@property(nonatomic, retain) NSObject <AFSettingProvider> *provider;

@end
