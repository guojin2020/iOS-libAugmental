#import "AFUILib.h"

@implementation AFUILib

+ (UILabel *)alloc2LineTitleLabelWithText:(NSString *)text
{
    UILabel *navTitleLabel = [[UILabel alloc] init];
    [navTitleLabel setText:text];
    navTitleLabel.frame           = CGRectMake(64, -5, 400, 44);
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.textColor       = [UIColor whiteColor];
    navTitleLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    navTitleLabel.numberOfLines   = 2;
    return navTitleLabel;
}

@end
