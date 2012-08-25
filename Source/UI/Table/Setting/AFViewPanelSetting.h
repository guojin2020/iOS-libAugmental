#import <Foundation/Foundation.h>
#import "AFTableCell.h"

#import "AFBaseSetting.h"
#import "AFSettingViewPanelObserver.h"
#import "AFThemeable.h"

#define THEME_KEY_EDIT_ICON @"editIcon"

@protocol AFSettingPersistenceDelegate;

/**
 * AFSettings are intended to have a UI control which fits inside a single AFTableCell, e.g. a slider, text field
 * or check box etc.
 * AFViewPanelSetting is an subclass of AFBaseSetting which allows for settings with more complicated UIs than
 * a single control. It holds a reference to an AFNavigationController and UIViewController which are used to
 * present the controls for the setting.
 */
@interface AFViewPanelSetting : AFBaseSetting <AFSettingViewPanelObserver, AFThemeable>
{
    UIImage     *labelIcon;
    UILabel     *optionLabel;
    UILabel     *valueLabel;
    UIImageView *editableOptionIcon;

    /**
      * The view panel controller that presents the controls needed to modify this AFViewPanelSettings value. e.g. A Picker, Map or graph etc.
      */
    AFSettingViewPanelController *panelViewController;
}

- (id)initWithIdentity:(NSString *)identityIn
             labelText:(NSString *)labelTextIn
             labelIcon:(UIImage *)labelIconIn
   panelViewController:(AFSettingViewPanelController *)panelViewControllerIn;

+ (UIImage *)editIcon;

@property(nonatomic, retain) NSString *valueString;

@end
