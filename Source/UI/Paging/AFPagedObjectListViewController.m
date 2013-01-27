#import "AFPagedObjectListViewController.h"
#import "AFTable.h"
#import "AFObjectTableCell.h"
#import "AFObjectTableSection.h"
#import "AFResultsPage.h"
#import "AFResultsPagingCell.h"
#import "AFPagedObjectQuery.h"

#import "AFMessageCell.h"
#import "AFPagedObjectListViewObserver.h"
#import "AFPageScrubbingTableCell.h"

static AFTableCell *defaultNoResultsCell;
static AFTableCell *resultsLoadingCell;

@implementation AFPagedObjectListViewController

+ (void)initialize
{
    defaultNoResultsCell = [[[AFMessageCell alloc] initWithLabelText:@"There are no results to show"] retain];
    resultsLoadingCell   = [[[AFMessageCell alloc] initWithLabelText:@"Search results are loading..."] retain];
}

- (id)initWithQuery:(AFPagedObjectQuery *)queryIn
              title:(NSString *)titleIn
  selectionDelegate:(NSObject <AFCellSelectionDelegate> *)selectionDelegateIn
      pageObservers:(NSSet *)initialObservers;
{
    self = [self init];
    if (self)
    {
        firstUpdate        = YES;
        currentResultsPage = nil;

        observers = [[NSMutableSet alloc] initWithSet:initialObservers];

        noResultsCell = defaultNoResultsCell;

        resultsTable        = [[AFTable alloc] initWithTitle:titleIn];
        selectionDelegate   = [selectionDelegateIn retain];
        resultsTableSection = [[AFObjectTableSection alloc] initWithTitle:@"Search Results"];
        self.table = resultsTable;
        [resultsTable addSection:resultsTableSection];

        pageScrubbingCell    = [[AFPageScrubbingTableCell alloc] initWithPagedObjectListViewController:self];
        pageScrubbingSection = [[AFTableSection alloc] initWithTitle:@""];
        [pageScrubbingSection addCell:pageScrubbingCell];

        [self setQuery:queryIn];

        pageObjectSortSelector = nil;
    }
    return self;
}

+ (AFTableCell *)defaultNoResultsCell
{return defaultNoResultsCell;}

+ (AFTableCell *)resultsLoadingCell
{return resultsLoadingCell;}

- (int)currentResultsPageNumber
{return query.currentPageNumber;}

- (void)addObserver:(NSObject <AFPagedObjectListViewObserver> *)observerIn
{[observers addObject:observerIn];}

- (void)removeObserver:(NSObject <AFPagedObjectListViewObserver> *)observerIn
{[observers removeObject:observerIn];}

- (void)resultsPageUpdated:(AFResultsPage *)resultsPage
{
    for (NSObject <AFPagedObjectListViewObserver> *observer in observers)[observer pageRefreshWillStart:self];

    firstUpdate = NO;
    [currentResultsPage release];
    currentResultsPage = [resultsPage retain];

    [resultsTableSection removeAllCells];

    //[observers removeObject:pageScrubbingCell];

    if (!resultsPage || resultsPage.resultsCount == 0)
    {
        [resultsTableSection addCell:noResultsCell];
    }
    else
    {
        int pages = (int) ceil((resultsPage.resultsCount - 1) / resultsPage.resultsPerPage);

        //Add results header
        AFTableCell *headerCell = [[AFResultsPagingCell alloc] initWithConfiguration:(resultsPage.currentPage > 1 ? AFPagingCellConfigurationTopBetweenPage : AFPagingCellConfigurationTopFirstPage) resultsPage:resultsPage];
        headerCell.selectionDelegate = self;

        NSMutableArray *objectArray = (NSMutableArray *) resultsPage.pageObjects;

        if ([objectArray count] == 0)
        {
            [resultsTableSection addCell:noResultsCell];
        }
        else
        {
            [resultsTableSection beginAtomic];

            [resultsTableSection addCell:headerCell];

            for (AFObject<AFCellViewable> *cellObject in objectArray)
            {
                AFObjectTableCell *cell = [resultsTableSection addObject:cellObject];
                for (NSObject <AFPagedObjectListViewObserver> *observer in observers)[observer cellAdded:cell toPage:self];
            }

            //Set self as the handler for touches on the cells
            for (int i = 1; i < [resultsTableSection cellCount]; i++) [resultsTableSection cellAtIndex:(NSUInteger) i].selectionDelegate = selectionDelegate;

            //Add next results optionsƒ
            AFTableCell *footerCell = [[AFResultsPagingCell alloc] initWithConfiguration:(resultsPage.currentPage <= pages ? AFPagingCellConfigurationBottomBetweenPage : AFPagingCellConfigurationBottomLastPage) resultsPage:resultsPage];
            footerCell.selectionDelegate = self;
            [resultsTableSection addCell:footerCell];
            [footerCell release];

            if (pages > 1 && !(pageScrubbingSection.parentTable))
            {
                [resultsTable addSection:pageScrubbingSection];
            }
            else if (pages <= 1 && pageScrubbingSection.parentTable)
            {
                [resultsTable removeSection:pageScrubbingSection];
            }

            [resultsTableSection completeAtomic];
        }

        [headerCell release];

        //Reload the table!
        [(UITableView*)self.view performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

        NSUInteger bottomIndexPath[] = {[resultsTable sectionCount] - 1, (NSUInteger) ([[resultsTable sectionAtIndex:[resultsTable sectionCount] - 1] cellCount] - 1)};
        NSUInteger topIndexPath[]    = {0, 0};

        switch (scrollNeed)
        {
            case (AFScrollIntent) AFScrollIntentNone:
                break;
            case (AFScrollIntent) AFScrollIntentTop:
                //[resultsTableController.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                [(UITableView *) (self.view) scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:topIndexPath length:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                scrollNeed = (AFScrollIntent) AFScrollIntentNone;
                break;
            case (AFScrollIntent) AFScrollIntentBottom:
                //[resultsTableController.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:YES];

                [(UITableView *) (self.view) scrollToRowAtIndexPath:[NSIndexPath indexPathWithIndexes:bottomIndexPath length:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                scrollNeed = (AFScrollIntent) AFScrollIntentNone;
                break;
        }
    }

    [waitAlert dismiss];
    [waitAlert release];

    for (NSObject <AFPagedObjectListViewObserver> *observer in observers)[observer pageRefreshDidFinish:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (firstUpdate)
    {
        noResultsCell = [AFPagedObjectListViewController resultsLoadingCell];
        [self resultsPageUpdated:nil];
        noResultsCell = [AFPagedObjectListViewController defaultNoResultsCell];
        [waitAlert    = [[AFSpinAlertView alloc] initWithTitle:@"Getting search results" message:nil] show];
    }
    firstUpdate = NO;
}

/*
-(void)pageEnd
{
	for(NSObject<AFPagedObjectListViewObserver>* observer in observers)[observer pageRefreshDidFinish:self];
}
*/

- (void)setQuery:(AFPagedObjectQuery *)queryIn
{
    AFPagedObjectQuery *oldQuery = query;
    query = [queryIn retain];
    [query addObserver:self];
    [oldQuery removeObserver:self];
    [oldQuery release];
    [query refresh];
}

- (void)cellSelected:(AFTableCell *)cell
{
    if ([cell isKindOfClass:[AFResultsPagingCell class]])
    {
        switch (((AFResultsPagingCell *) cell).configuration)
        {
            case (AFPagingCellConfiguration) AFPagingCellConfigurationTopFirstPage:
            case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomLastPage:
                break;
            case (AFPagingCellConfiguration) AFPagingCellConfigurationTopBetweenPage:
                [self goToResultsPage:query.currentPageNumber - 1];
                scrollNeed = (AFScrollIntent) AFScrollIntentBottom;
                break;
            case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomBetweenPage:
                [self goToResultsPage:query.currentPageNumber + 1];
                scrollNeed = (AFScrollIntent) AFScrollIntentTop;
                break;
        }
    }
    else
    {
        [selectionDelegate cellSelected:cell];
    }
}

- (void)goToResultsPage:(int)page
{
    [waitAlert = [[AFSpinAlertView alloc] initWithTitle:@"Please wait" message:nil] show];
    query.currentPageNumber = (uint8_t) page;
}

- (NSString *)queryString
{return query.queryString;}

- (void)dealloc
{
    [pageScrubbingCell release];
    [selectionDelegate release];
    [waitAlert release];
    [resultsTable release];
    [resultsTableSection release];
    [observers release];
    [pageScrubbingSection release];
    [currentResultsPage release];
    [query release];
    [noResultsCell release];
    [super dealloc];
}

@synthesize pageObjectSortSelector, query, currentResultsPage, noResultsCell;

@end
