#import "AFUnavailableOfflineViewController.h"
#import "AFObservable.h"
#import "AFSession.h"

@implementation AFUnavailableOfflineViewController

- (id)initWithTitle:(NSString *)titleIn
{
    if ((self = [self initWithNibName:@"AFUnavailableOfflineViewController" bundle:[NSBundle mainBundle]]))
    {
        title = titleIn;
    }
    return self;
}

- (IBAction)reconnectButtonTouched:(id)sender
{
    //Try to switch the Session online!
    [[AFSession sharedSession] setOffline:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleLabel.text = [NSString stringWithFormat:@"%@ Unavailable", title];
}


@synthesize reconnectButton, titleLabel;

@end
