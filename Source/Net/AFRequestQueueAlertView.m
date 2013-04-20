#import "AFRequestQueueAlertView.h"
#import "AFObservable.h"
#import "AFRequestQueue.h"
#import "AFCellViewFactory.h"

#define REQUEST_ROW_HEIGHT 32
#define REQUEST_SECTION_HEADER_TEXT nil;
#define REQUEST_SECTION_HEADER_HEIGHT 0;

static AFRequestQueueAlertView *alert = nil;
static AFRequestQueue          *visibleQueue = nil;

@interface AFRequestQueueAlertView ()

@property(nonatomic, retain) NSArray *activatedRequestCache;

@end

@implementation AFRequestQueueAlertView

- (id)initWithRequestQueue:(AFRequestQueue *)queueIn
{
    if ((self = [super initWithTitle:@"Requests" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil]))
    {
        queue = [queueIn retain];
        [self setDelegate:self];
        [self setTableData:self];
        [self setTableDelegate:self];

        headingRow = [[[AFCellViewFactory defaultFactory] cellOfKind:@"requestCell" forTable:nil reuseIdentifier:@"headingRow"] retain];
        ((UILabel *) [headingRow viewWithTag:1]).text      = @"#";
        ((UILabel *) [headingRow viewWithTag:1]).textColor = [UIColor whiteColor];
        ((UILabel *) [headingRow viewWithTag:2]).text      = @"Request type";
        ((UILabel *) [headingRow viewWithTag:2]).textColor = [UIColor whiteColor];
        ((UILabel *) [headingRow viewWithTag:3]).text      = @"Attempt";
        ((UILabel *) [headingRow viewWithTag:3]).textColor = [UIColor whiteColor];
        [headingRow setBackgroundColor:[UIColor darkGrayColor]];

    }
    return self;
}

+ (void)showAlertForQueue:(AFRequestQueue *)queueIn
{
    if (!queueIn) return;

    if (visibleQueue == queueIn)
    {
        //If we're already showing this RequestQueue, refresh it
        [alert reloadTableData];
    }
    else
    {
        //Otherwise, let's create a new view and show it
        visibleQueue = [queueIn retain];
        alert = [[AFRequestQueueAlertView alloc] initWithRequestQueue:queueIn];
        [alert show];
    }
}

//UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //AFLog(@"RequestQueueAlert dismissed");
    [queue release];
    [alert release];
    queue = nil;
    alert = nil;
}

// Called when we AFRequestEventCancel a view (eg. the user clicks the Home button). This is not called when the USER clicks the AFRequestEventCancel button.
// If not defined in the delegate, we simulate a click in the AFRequestEventCancel button
//- (void)alertViewCancel:(UIAlertView *)alertView{}
- (void)willPresentAlertView:(UIAlertView *)alertView
{}

- (void)didPresentAlertView:(UIAlertView *)alertView
{}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{}

//UITableViewDataSource

//Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //AFLog(@"Request rows: %i",[queue.activeRequests count]);
    return [activatedRequestCache count] + [queue.queue count];
}

- (void)reloadTableData
{
    self.activatedRequestCache = [queue.activeRequests allObjects];
    [super reloadTableData];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewIn cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0)return headingRow;
    else row--;

    AFRequest*request;
    if (row < [activatedRequestCache count])
    {
        request = [activatedRequestCache objectAtIndex:(NSUInteger) row];
    }
    else
    {
        request = [queue.queue objectAtIndex:(NSUInteger) (row - [activatedRequestCache count])];
    }

    UITableViewCell *cell = [[AFCellViewFactory defaultFactory] cellOfKind:@"requestCell" forTable:tableViewIn reuseIdentifier:[NSString stringWithFormat:@"%@", request]];

    ((UILabel *) [cell viewWithTag:1]).text      = [NSString stringWithFormat:@"%i", indexPath.row - 1];
    ((UILabel *) [cell viewWithTag:1]).textColor = [UIColor blackColor];
    ((UILabel *) [cell viewWithTag:2]).text      = [request actionDescription];
    ((UILabel *) [cell viewWithTag:2]).textColor = [UIColor blackColor];
    ((UILabel *) [cell viewWithTag:3]).text      = [NSString stringWithFormat:@"%i/%i", request.attempts, REQUEST_RETRY_LIMIT];
    ((UILabel *) [cell viewWithTag:3]).textColor = [UIColor blackColor];
    [cell setBackgroundColor:indexPath.row < [activatedRequestCache count] ? [UIColor whiteColor] : [UIColor lightGrayColor]];

    return cell;
}


//Optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //AFLog(@"requestAlert section query");
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSAssert(section == 0, @"Invalid section");
    return REQUEST_SECTION_HEADER_TEXT;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{return nil;}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{return NO;}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{return NO;}

//UITableViewDelegate

//Optional
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{return REQUEST_ROW_HEIGHT;}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{return REQUEST_SECTION_HEADER_HEIGHT;}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{return 0;}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Possibly display a detail view of the request
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{return NO;}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{return sourceIndexPath;}

- (void)dealloc
{
    [headingRow release];

    [queue release];
    [visibleQueue release];
    [activatedRequestCache release];
    [super dealloc];
}

@synthesize activatedRequestCache;

@end
