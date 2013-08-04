#import <UIKit/UIKit.h>

@class AFSession;

@interface AFUnavailableOfflineViewController : UIViewController
{
    UIButton *reconnectButton;
    UILabel  *titleLabel;
    NSString *title;
}

- (id)initWithTitle:(NSString *)titleIn;

- (IBAction)reconnectButtonTouched:(id)sender;

@property(nonatomic, strong) IBOutlet UIButton *reconnectButton;
@property(nonatomic, strong) IBOutlet UILabel  *titleLabel;

@end
