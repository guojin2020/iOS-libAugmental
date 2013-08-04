#import <Foundation/Foundation.h>
#import "AFTableCell.h"
#import "AFPagedObjectListViewObserver.h"
#import "AFPThemeable.h"

#define THEME_KEY_TEXT_COLOR                @"textColor"
#define THEME_KEY_TEXT_SHADOW_COLOR            @"textShadowColor"
#define THEME_KEY_TEXT_SHADOW_ENABLED        @"textShadowEnabled"

@interface AFPageScrubbingTableCell : AFTableCell <AFPagedObjectListViewObserver, AFPThemeable>
{
    AFPagedObjectListViewController *pagedObjectListViewController;

    UILabel  *headerLabel;
    UILabel  *pageLabel;
    UISlider *slider;

    int pageCount;

    BOOL suppressSecondEvent;
}

- (id)initWithPagedObjectListViewController:(AFPagedObjectListViewController *)pagedObjectListViewController;

+ (UIColor *)textColor;

+ (UIColor *)textShadowColor;

+ (BOOL)textShadowEnabled;

@property(nonatomic, strong) UILabel  *headerLabel;
@property(nonatomic, strong) UILabel  *pageLabel;
@property(nonatomic, strong) UISlider *slider;

@end
