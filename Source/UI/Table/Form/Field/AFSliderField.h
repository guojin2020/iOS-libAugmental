#import <Foundation/Foundation.h>
#import "AFBaseField.h"
#import "AFField.h"

@protocol AFFieldPersistenceDelegate;

@interface AFSliderField : AFBaseField <AFField>
{
    UISlider *slider;
    float minimum;
    float maximum;
}

- (id)initWithIdentity:(NSString *)identityIn
               minimum:(float)minimumIn
               maximum:(float)maximumIn;
@end
