#import <Foundation/Foundation.h>
#import "AFTextField.h"

@interface AFPasswordField : AFTextField
{
    AFPasswordField *counterpart;
}

- (id)initWithIdentity:(NSString *)identityIn
           allowsEmpty:(BOOL)allowsEmptyIn;

- (void)counterpartUpdated;

@property(nonatomic, retain) AFPasswordField *counterpart;

@end
