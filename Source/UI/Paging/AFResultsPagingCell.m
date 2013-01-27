#import "AFResultsPagingCell.h"
#import "AFResultsPage.h"
#import "AFThemeManager.h"

static UIColor *bgColor;
static UIColor *textColor;
static UIImage *imageNext;
static UIImage *imagePrevious;

@interface AFResultsPagingCell ()

@end

@implementation AFResultsPagingCell

- (id)initWithConfiguration:(AFPagingCellConfiguration)configurationIn resultsPage:(AFResultsPage *)resultsPageIn
{
    self = [self init];
    if (self)
    {
        configuration = configurationIn;
        showingLabel = nil;
        swipeImageView = nil;
        resultsPage = [resultsPageIn retain];
    }
    return self;
}

+ (UIColor *)bgColor
{
    if (!bgColor)
    {bgColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFResultsPagingCell class]] colorForKey:THEME_KEY_BG_COLOR] retain];}
    return bgColor;
}

+ (UIColor *)textColor
{
    if (!textColor)
    {textColor = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFResultsPagingCell class]] colorForKey:THEME_KEY_TEXT_COLOR] retain];}
    return textColor;
}

+ (UIImage *)imageNext
{
    if (!imageNext)
    {imageNext = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFResultsPagingCell class]] imageForKey:THEME_KEY_IMAGE_NEXT] retain];}
    return imageNext;
}

+ (UIImage *)imagePrevious
{
    if (!imagePrevious)
    {imagePrevious = [[[AFThemeManager themeSectionForClass:(id<AFThemeable>)[AFResultsPagingCell class]] imageForKey:THEME_KEY_IMAGE_PREVIOUS] retain];}
    return imagePrevious;
}

- (UITableViewCell *)viewCellForTableView:(UITableView *)tableIn
{
    if (!cell || self.tableView != tableIn)
    {
        switch (configuration)
        {
            case (AFPagingCellConfiguration) AFPagingCellConfigurationTopFirstPage:
            case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomLastPage:
                self.cell = [super viewCellForTableView:tableIn templateName:@"pagingCell_End"];
                break;

            case (AFPagingCellConfiguration) AFPagingCellConfigurationTopBetweenPage:
                self.cell = [super viewCellForTableView:tableIn templateName:@"pagingCell_MidTop"];
                swipeImageView = (UIImageView *) [cell viewWithTag:2];
                [swipeImageView setImage:[AFResultsPagingCell imagePrevious]];

                break;
            case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomBetweenPage:
                self.cell = [super viewCellForTableView:tableIn templateName:@"pagingCell_MidBottom"];
                swipeImageView = (UIImageView *) [cell viewWithTag:2];
                [swipeImageView setImage:[AFResultsPagingCell imageNext]];
                break;
        }
    }

    return cell;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    switch (configuration)
    {
        case (AFPagingCellConfiguration) AFPagingCellConfigurationTopFirstPage:
        case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomLastPage:
            break;

        case (AFPagingCellConfiguration) AFPagingCellConfigurationTopBetweenPage:
            swipeImageView = (UIImageView *) [cell viewWithTag:2];
            [swipeImageView setImage:[AFResultsPagingCell imagePrevious]];

            break;
        case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomBetweenPage:
            swipeImageView = (UIImageView *) [cell viewWithTag:2];
            [swipeImageView setImage:[AFResultsPagingCell imageNext]];
            break;
    }

    self.fillColor = [AFResultsPagingCell bgColor];

    showingLabel = (UILabel *) [cell viewWithTag:1];

    [showingLabel setTextColor:[AFResultsPagingCell textColor]];

    int startIndex = (resultsPage.currentPage - 1) * resultsPage.resultsPerPage + 1;
    int endIndex   = resultsPage.currentPage * resultsPage.resultsPerPage;
    if (endIndex > resultsPage.resultsCount) endIndex = resultsPage.resultsCount;

    [showingLabel setText:[NSString stringWithFormat:@"Showing %i-%i of %i", startIndex, endIndex, resultsPage.resultsCount]];
}

+ (id<AFThemeable>)themeParentSectionClass
{return (id<AFThemeable>)[AFTableCell class];}

+ (NSString *)themeSectionName
{return @"resultsPagingCell";}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"B85430", THEME_KEY_BG_COLOR,
            @"FFFFFF", THEME_KEY_TEXT_COLOR,
            @"PageEndChevronRight", THEME_KEY_IMAGE_NEXT,
            @"PageEndChevronLeft", THEME_KEY_IMAGE_PREVIOUS, nil];
}

- (NSString *)cellTemplateName
{return @"resultsPagingCell";}

- (void)dealloc
{
    [resultsPage release];
    [super dealloc];
}

@synthesize configuration;

@end
