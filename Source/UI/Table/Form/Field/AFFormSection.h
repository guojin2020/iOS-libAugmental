
#import <Foundation/Foundation.h>
#import "AFTableSection.h"

@class      AFTableCell;
@protocol   AFSettingProvider;
@class      AFField;

@interface AFFormSection : AFTableSection
{
    NSString                     *name;
    NSObject <AFSettingProvider> *provider;
}

- (id)initWithTitle:(NSString *)title provider:(NSObject <AFSettingProvider> *)providerIn;

- (void)addField:(AFField*)field;

@property(nonatomic, strong) NSObject <AFSettingProvider> *provider;

@end
