#import <Foundation/Foundation.h>
#import "AFTableCell.h"

#import "AFField.h"
#import "AFFieldViewPanelObserver.h"
#import "AFPThemeable.h"

#define THEME_KEY_EDIT_ICON @"editIcon"

@protocol AFFieldPersistenceDelegate;

/**
 * AFSettings are intended to have a UI control which fits inside a single AFTableCell, e.g. a slider, text field
 * or check box etc.
 * AFViewPanelField is an subclass of AFField which allows for settings with more complicated UIs than
 * a single control. It holds a reference to an AFNavigationController and UIViewController which are used to
 * present the controls for the setting.
 */
@interface AFViewPanelField : AFField <AFFieldViewPanelObserver, AFPThemeable>
{
    UIImage     *labelIcon;
    UILabel     *optionLabel;
    UILabel     *valueLabel;
    UIImageView *editableOptionIcon;

    /**
      * The view panel controller that presents the controls needed to modify this AFViewPanelSettings value. e.g. A Picker, Map or graph etc.
      */
    AFFieldViewPanelController *panelViewController;
}

- (id)initWithIdentity:(NSString *)identityIn
             labelText:(NSString *)labelTextIn
             labelIcon:(UIImage *)labelIconIn
   panelViewController:(AFFieldViewPanelController *)panelViewControllerIn;

+ (UIImage *)editIcon;

@property(nonatomic, strong) NSString *valueString;

@end
