#import "AFPageScrubbingTableCell.h"
#import "AFResultsPage.h"
#import "AFThemeManager.h"

static UIColor  *textColor;
static UIColor  *textShadowColor;
static NSNumber *textShadowEnabled;

@interface AFPageScrubbingTableCell ()

- (void)updateScrubber;

- (void)editingDidBegin:(id)sender;

- (void)editingDidEnd:(id)sender;

- (void)editingChanged:(id)sender;

@end

@implementation AFPageScrubbingTableCell

- (id)initWithPagedObjectListViewController:(AFPagedObjectListViewController *)pagedObjectListViewControllerIn
{
    self = [self init];
    if (self)
    {
        suppressSecondEvent           = NO;
        pagedObjectListViewController = pagedObjectListViewControllerIn;
        [pagedObjectListViewController addObserver:self];
    }
    return self;
}

+ (UIColor *)textColor
{
    if (!textColor)textColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFPageScrubbingTableCell class]] colorForKey:THEME_KEY_TEXT_COLOR];
    return textColor;
}

+ (UIColor *)textShadowColor
{
    if (!textShadowColor)textShadowColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFPageScrubbingTableCell class]] colorForKey:THEME_KEY_TEXT_COLOR];
    return textShadowColor;
}

+ (BOOL)textShadowEnabled
{
    if (!textShadowEnabled)textShadowEnabled = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFPageScrubbingTableCell class]] valueForKey:THEME_KEY_TEXT_SHADOW_ENABLED];
    return [textShadowEnabled boolValue];
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    headerLabel = (UILabel *) [cell viewWithTag:1];
    pageLabel   = (UILabel *) [cell viewWithTag:3];
    slider      = (UISlider *) [cell viewWithTag:2];

    [headerLabel setTextColor:[AFPageScrubbingTableCell textColor]];
    [pageLabel setTextColor:[AFPageScrubbingTableCell textColor]];


    if ([AFPageScrubbingTableCell textShadowEnabled])
    {
        [headerLabel setShadowColor:[AFPageScrubbingTableCell textShadowColor]];
        [pageLabel setShadowColor:[AFPageScrubbingTableCell textShadowColor]];
        [headerLabel setShadowOffset:CGSizeMake(1, 1)];
        [pageLabel setShadowOffset:CGSizeMake(1, 1)];
    }
    else
    {
        [headerLabel setShadowColor:[UIColor clearColor]];
        [pageLabel setShadowColor:[UIColor clearColor]];
        [headerLabel setShadowOffset:CGSizeMake(0, 0)];
        [pageLabel setShadowOffset:CGSizeMake(0, 0)];
    }


    [slider setMinimumValue:1.00f];
    [slider setMaximumValue:(float) pageCount];

    [self updateScrubber];

    [slider addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventValueChanged];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView      = backView;
}

- (void)updateScrubber
{
    pageCount = (int) ceil((float) (pagedObjectListViewController.currentResultsPage.resultsCount) / (float) (pagedObjectListViewController.currentResultsPage.resultsPerPage));

    int currentPage = pagedObjectListViewController.currentResultsPage.currentPage;

    pageLabel.text = [NSString stringWithFormat:@"Page %i of %i", currentPage, pageCount];

    [slider setMaximumValue:(float) pageCount];
    [slider setValue:(float) currentPage];
}

//===================>> Control methods

- (void)editingDidBegin:(id)sender
{}

- (void)editingDidEnd:(id)sender
{
    if (suppressSecondEvent)
    {
        suppressSecondEvent = NO;
        return;
    }
    else suppressSecondEvent = YES;

    int soughtPage = (int) round([slider value]);
    if (round([slider value]) != pagedObjectListViewController.currentResultsPage.currentPage)
    {
        pageLabel.text = [NSString stringWithFormat:@"Seeking to page %i", soughtPage];
        [pagedObjectListViewController goToResultsPage:soughtPage];
    }
    else
    {
        [self updateScrubber];
    }
}

- (void)editingChanged:(id)sender
{
    if ([sender isTracking])
    {
        int seekPage = (int) round([slider value]);
        if (seekPage == pagedObjectListViewController.currentResultsPage.currentPage)
        {
            pageLabel.text = @"Current page";
        }
        else
        {
            pageLabel.text = [NSString stringWithFormat:@"Go to page %i of %i", seekPage, pageCount];
        }
    }
}

//===================>> PagedObjectListViewObserver

- (void)pageRefreshWillStart:(AFPagedObjectListViewController *)objectListViewController
{
    //[cell setHidden:YES];
}

- (void)pageRefreshDidFinish:(AFPagedObjectListViewController *)objectListViewController
{
    //AFLog(@"SCRUBBIN DAT FINISH!");
    //[cell setHidden:NO];

    [self updateScrubber];
}

- (void)cellAdded:(AFObjectTableCell*)cellIn toPage:(AFPagedObjectListViewController *)objectListViewController
{}

//=============>> Themeable

- (void)themeChanged
{textColor = nil;}

+ (id<AFPThemeable>)themeParentSectionClass
{return (id<AFPThemeable>)[AFTableCell class];}

+ (NSString *)themeSectionName
{return @"pageScrubbingCell";}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"000000", THEME_KEY_TEXT_COLOR,
            @"FFFFFF", THEME_KEY_TEXT_SHADOW_COLOR,
            [NSNumber numberWithBool:NO], THEME_KEY_TEXT_SHADOW_ENABLED,
            nil];
}

//=============>> Dealloc

- (void)dealloc
{
    [pagedObjectListViewController removeObserver:self];
}

@synthesize headerLabel, pageLabel, slider;

@end
