#import <Foundation/Foundation.h>
#import "AFTableCell.h"
#import "AFThemeable.h"

#define THEME_KEY_BG_COLOR            @"bgColor"
#define THEME_KEY_TEXT_COLOR        @"textColor"
#define THEME_KEY_IMAGE_NEXT        @"imageNext"
#define THEME_KEY_IMAGE_PREVIOUS    @"imagePrevious"

@class AFResultsPage;

typedef enum
{
    topFirstPage = 0, topBetweenPage = 1, bottomLastPage = 2, bottomBetweenPage = 3
} PagingCellConfiguration;

@interface AFResultsPagingCell : AFTableCell <AFThemeable>
{
    UILabel     *showingLabel;
    UIImageView *swipeImageView;
    PagingCellConfiguration configuration;
    AFResultsPage *resultsPage;
}

- (id)initWithConfiguration:(PagingCellConfiguration)configurationIn resultsPage:(AFResultsPage *)resultsPage;

+ (UIColor *)bgColor;

+ (UIColor *)textColor;

+ (UIImage *)imageNext;

+ (UIImage *)imagePrevious;

@property(nonatomic) PagingCellConfiguration configuration;

@end
