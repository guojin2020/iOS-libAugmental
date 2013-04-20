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

@property(nonatomic, retain) UILabel  *headerLabel;
@property(nonatomic, retain) UILabel  *pageLabel;
@property(nonatomic, retain) UISlider *slider;

@end
