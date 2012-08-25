#import <Foundation/Foundation.h>
#import "AFTextSetting.h"

@interface AFPasswordSetting : AFTextSetting
{
    AFPasswordSetting *counterpart;
}

- (id)initWithIdentity:(NSString *)identityIn
           allowsEmpty:(BOOL)allowsEmptyIn;

- (void)counterpartUpdated;

@property(nonatomic, retain) AFPasswordSetting *counterpart;

@end
