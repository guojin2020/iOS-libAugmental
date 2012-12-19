#import <Foundation/Foundation.h>
#import "AFField.h"
#import "AFField.h"

@protocol AFFieldPersistenceDelegate;

@interface AFSliderField : AFField
{
    UISlider *slider;
    float minimum;
    float maximum;
}

- (id)initWithIdentity:(NSString *)identityIn
               minimum:(float)minimumIn
               maximum:(float)maximumIn;
@end
