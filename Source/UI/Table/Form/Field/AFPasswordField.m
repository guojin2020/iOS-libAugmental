#import "AFPasswordField.h"
#import "AFPasswordValidator.h"

@implementation AFPasswordField

- (id)initWithIdentity:(NSString *)identityIn
           allowsEmpty:(BOOL)allowsEmptyIn
{
    if ((self = [super initWithIdentity:identityIn]))
    {
        [self.validator = [[AFPasswordValidator alloc] initWithComparisonSetting:nil allowsEmpty:allowsEmptyIn] release];
    }
    return self;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    textField.secureTextEntry = YES;
}


- (void)setValue:(NSObject <NSCoding> *)valueIn
{
    [super setValue:valueIn];
    [counterpart counterpartUpdated];
}

- (void)counterpartUpdated
{
    valueChangedSinceLastValidation = YES;
    [self updateControlCell];
}

- (void)setCounterpart:(AFPasswordField *)counterpartIn
{
    AFPasswordField *oldCounterpart = counterpart;
    counterpart = [counterpartIn retain];
    [oldCounterpart release];

    ((AFPasswordValidator *) self.validator).comparisonSetting = counterpart;
}

- (void)dealloc
{
    [counterpart release];
    [counterpart release];
    [super dealloc];
}

@synthesize counterpart;

@end
