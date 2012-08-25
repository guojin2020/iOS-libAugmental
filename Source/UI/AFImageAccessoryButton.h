#import <Foundation/Foundation.h>

@interface AFImageAccessoryButton : UIControl
{
    UIImage     *image;
    UIImageView *imageView;
    NSObject    *targetObject;
    SEL targetSelector;

    UIControlEvents events;

    CGAffineTransform baseTransform;
}

- (id)initWithImage:(UIImage *)imageIn target:(NSObject *)objectIn action:(SEL)selectorIn;

- (void)setImage:(UIImage *)imageIn;

@property(nonatomic, assign) CGAffineTransform imageTransform;

@end
