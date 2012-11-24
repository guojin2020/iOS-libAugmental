#import "AFStringListPickerViewController.h"

@implementation AFStringListPickerViewController

- (id)initWithStrings:(NSArray *)objectsIn title:(NSString *)titleIn;
{
    if ((self = [super initWithObjects:objectsIn delegate:self title:titleIn]))
    {
        //NSLog(@"String picker objects: %@",objectsIn);

        self.defaultValue = [objects objectAtIndex:0];
    }
    return self;
}

- (NSString *)titleForObject:(NSObject *)object
{
    return (NSString *) object;
}

@end
