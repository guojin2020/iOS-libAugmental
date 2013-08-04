#import "AFStringListPickerViewController.h"

@implementation AFStringListPickerViewController

- (id)initWithStrings:(NSArray *)objectsIn title:(NSString *)titleIn;
{
    if ((self = [super initWithObjects:objectsIn delegate:self title:titleIn]))
    {
        //AFLog(@"String picker objects: %@",objectsIn);

        self.defaultValue = objects[0];
    }
    return self;
}

- (NSString *)titleForObject:(NSObject *)object
{
    return (NSString *) object;
}

@end
