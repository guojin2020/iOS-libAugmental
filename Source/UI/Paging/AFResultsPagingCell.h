#import <Foundation/Foundation.h>
#import "AFTableCell.h"
#import "AFPThemeable.h"

#define THEME_KEY_BG_COLOR            @"bgColor"
#define THEME_KEY_TEXT_COLOR        @"textColor"
#define THEME_KEY_IMAGE_NEXT        @"imageNext"
#define THEME_KEY_IMAGE_PREVIOUS    @"imagePrevious"

@class AFResultsPage;

typedef enum AFPagingCellConfiguration
{
    AFPagingCellConfigurationTopFirstPage       = 0,
    AFPagingCellConfigurationTopBetweenPage     = 1,
    AFPagingCellConfigurationBottomLastPage     = 2,
    AFPagingCellConfigurationBottomBetweenPage  = 3
}
AFPagingCellConfiguration;

@interface AFResultsPagingCell : AFTableCell <AFPThemeable>
{
    UILabel     *showingLabel;
    UIImageView *swipeImageView;
    AFPagingCellConfiguration configuration;
    AFResultsPage *resultsPage;
}

- (id)initWithConfiguration:(AFPagingCellConfiguration)configurationIn resultsPage:(AFResultsPage *)resultsPage;

+ (UIColor *)bgColor;

+ (UIColor *)textColor;

+ (UIImage *)imageNext;

+ (UIImage *)imagePrevious;

@property(nonatomic) AFPagingCellConfiguration configuration;

@end
