#import "AFUnavailableOfflineViewController.h"
#import "AFSession.h"

@implementation AFUnavailableOfflineViewController

- (id)initWithTitle:(NSString *)titleIn
{
    if ((self = [self initWithNibName:@"AFUnavailableOfflineViewController" bundle:[NSBundle mainBundle]]))
    {
        title = [titleIn retain];
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

- (void)dealloc
{
    [title release];
    [reconnectButton release];
    [titleLabel release];
    [super dealloc];
}

@synthesize reconnectButton, titleLabel;

@end
