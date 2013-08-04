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
        resultsPage = resultsPageIn;
    }
    return self;
}

+ (UIColor *)bgColor
{
    if (!bgColor)
    {bgColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFResultsPagingCell class]] colorForKey:THEME_KEY_BG_COLOR];}
    return bgColor;
}

+ (UIColor *)textColor
{
    if (!textColor)
    {textColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFResultsPagingCell class]] colorForKey:THEME_KEY_TEXT_COLOR];}
    return textColor;
}

+ (UIImage *)imageNext
{
    if (!imageNext)
    {imageNext = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFResultsPagingCell class]] imageForKey:THEME_KEY_IMAGE_NEXT];}
    return imageNext;
}

+ (UIImage *)imagePrevious
{
    if (!imagePrevious)
    {imagePrevious = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFResultsPagingCell class]] imageForKey:THEME_KEY_IMAGE_PREVIOUS];}
    return imagePrevious;
}



- (UITableViewCell *)newCellForTableView:(UITableView *)tableIn
                            templateName:(NSString *)templateNameIn
{
    UITableViewCell *newCell;

    switch (configuration)
    {
        case (AFPagingCellConfiguration) AFPagingCellConfigurationTopFirstPage:
        case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomLastPage:
            newCell = [super viewCellForTableView:tableIn templateName:@"pagingCell_End"];
            break;

        case (AFPagingCellConfiguration) AFPagingCellConfigurationTopBetweenPage:
            newCell = [super viewCellForTableView:tableIn templateName:@"pagingCell_MidTop"];
            swipeImageView = (UIImageView *) [newCell viewWithTag:2];
            [swipeImageView setImage:[AFResultsPagingCell imagePrevious]];

            break;
        case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomBetweenPage:
            newCell = [super viewCellForTableView:tableIn templateName:@"pagingCell_MidBottom"];
            swipeImageView = (UIImageView *) [newCell viewWithTag:2];
            [swipeImageView setImage:[AFResultsPagingCell imageNext]];
            break;
    }

    return newCell;
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
            swipeImageView = (UIImageView *) [self.viewCell viewWithTag:2];
            [swipeImageView setImage:[AFResultsPagingCell imagePrevious]];

            break;
        case (AFPagingCellConfiguration) AFPagingCellConfigurationBottomBetweenPage:
            swipeImageView = (UIImageView *) [self.viewCell viewWithTag:2];
            [swipeImageView setImage:[AFResultsPagingCell imageNext]];
            break;
    }

    self.fillColor = [AFResultsPagingCell bgColor];

    showingLabel = (UILabel *) [self.viewCell viewWithTag:1];

    [showingLabel setTextColor:[AFResultsPagingCell textColor]];

    int startIndex = (resultsPage.currentPage - 1) * resultsPage.resultsPerPage + 1;
    int endIndex   = resultsPage.currentPage * resultsPage.resultsPerPage;
    if (endIndex > resultsPage.resultsCount) endIndex = resultsPage.resultsCount;

    [showingLabel setText:[NSString stringWithFormat:@"Showing %i-%i of %i", startIndex, endIndex, resultsPage.resultsCount]];
}

+ (id<AFPThemeable>)themeParentSectionClass
{return (id<AFPThemeable>)[AFTableCell class];}

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


@synthesize configuration;

@end
