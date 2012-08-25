#import <Foundation/Foundation.h>
#import "AFCellSelectionDelegate.h"
#import "AFPagedObjectQueryObserver.h"
#import "AFSpinAlertView.h"
#import "AFTableViewController.h"

@class AFObjectTableSection;
@class AFTable;
@class AFPagedObjectQuery;
@class AFSession;
@class AFResultsPage;

@class AFCellSelectionDelegate;
@class AFResultsPage;
@class AFPageScrubbingTableCell;
@class AFTableSection;
@class AFTableCell;

@protocol AFPagedObjectListViewObserver;

typedef enum needToScroll
{
    noScroll = 0, toTop = 1, toBottom, none = 2
} needToScroll;

@interface AFPagedObjectListViewController : AFTableViewController <AFCellSelectionDelegate, AFPagedObjectQueryObserver>
{
    AFPagedObjectQuery   *query;
    AFTable              *resultsTable;
    AFObjectTableSection *resultsTableSection;
    AFSpinAlertView      *waitAlert;
    needToScroll scrollNeed;
    AFResultsPage *currentResultsPage;
    BOOL firstUpdate;
    SEL  pageObjectSortSelector;

    AFPageScrubbingTableCell *pageScrubbingCell;
    AFTableSection           *pageScrubbingSection;

    NSMutableSet                       *observers;
    NSObject <AFCellSelectionDelegate> *selectionDelegate;

    AFTableCell *noResultsCell;
}

- (id)initWithQuery:(AFPagedObjectQuery *)queryIn
              title:(NSString *)titleIn
  selectionDelegate:(NSObject <AFCellSelectionDelegate> *)selectionDelegateIn
      pageObservers:(NSSet *)initialObservers;

- (void)goToResultsPage:(int)page;

- (void)setQuery:(AFPagedObjectQuery *)queryIn;

- (int)currentResultsPageNumber;

//-(void)pageEnd;

- (void)addObserver:(NSObject <AFPagedObjectListViewObserver> *)observerIn;

- (void)removeObserver:(NSObject <AFPagedObjectListViewObserver> *)observerIn;

+ (AFTableCell *)defaultNoResultsCell;

+ (AFTableCell *)resultsLoadingCell;

@property(nonatomic) SEL pageObjectSortSelector;
@property(nonatomic, readonly) AFResultsPage    *currentResultsPage;
@property(nonatomic, assign) AFPagedObjectQuery *query;
@property(nonatomic, retain) AFTableCell        *noResultsCell;

@end
