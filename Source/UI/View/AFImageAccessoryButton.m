#import "AFImageAccessoryButton.h"

@implementation AFImageAccessoryButton

//Set the size of this control (touch area), 44 is max. fit for height of UIViewCell
static const float size = 44;

- (id)initWithImage:(UIImage *)imageIn target:(id)objectIn action:(SEL)selectorIn
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, size, size)]))
    {
        image          = imageIn;
        targetObject   = objectIn;
        targetSelector = selectorIn;

        imageView = [[UIImageView alloc] initWithImage:image highlightedImage:image];

        //Translate the image view so that the image is in the middle of our touch area
        baseTransform = CGAffineTransformMakeTranslation((size - image.size.width) / 2, (size - image.size.height) / 2);
        self.imageTransform = CGAffineTransformMakeTranslation(0.0, 0.0);

        events = (UIControlEvents) (UIControlEventTouchDown);

        [self addSubview:imageView];

        [self addTarget:objectIn action:selectorIn forControlEvents:events];

        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)imageIn
{
    UIImage *oldImage = image;
    image = imageIn;

    imageView.image            = image;
    imageView.highlightedImage = image;
}


- (void)dealloc
{
    [self removeTarget:targetObject action:targetSelector forControlEvents:events];

}

- (CGAffineTransform)imageTransform
{return imageView.transform;}

- (void)setImageTransform:(CGAffineTransform)transform
{
    imageView.transform = CGAffineTransformConcat(baseTransform, transform);
}

@end
