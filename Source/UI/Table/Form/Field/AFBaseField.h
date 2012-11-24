#import "AFField.h"
#import "AFFieldObserver.h"
#import "AFFormSection.h"
#import "AFEventObserver.h"
#import "AFCellSelectionDelegate.h"
#import "AFTableCell.h"
#import "AFFieldPersistenceDelegate.h"
#import "AFThemeable.h"

#define THEME_KEY_VALID_COLOR    @"inputValidCellColor"
#define THEME_KEY_INVALID_COLOR @"inputInvalidCellColor"

@class AFTable;
@class AFTableSection;
@class AFTableViewController;

@protocol AFFieldPersistenceDelegate;
@protocol AFValidator;

@interface AFBaseField : AFTableCell <AFEventObserver, AFCellSelectionDelegate, AFThemeable>
{
    NSObject <AFFieldPersistenceDelegate> *persistenceDelegate;

    NSString     *identity;
    NSMutableSet *settingObservers;
    NSString     *helpText;

    BOOL lastValidationResult;
    BOOL valueChangedSinceLastValidation;

    NSObject <AFValidator> *validator;
    NSObject <NSCoding> *value;

}

- (id)initWithIdentity:(NSString *)identityIn persistenceDelegate:(NSObject <AFFieldPersistenceDelegate> *)persistenceDelegateIn defaultValue:(NSObject <NSCoding> *)defaultValue;

- (id)initWithIdentity:(NSString *)identityIn;

- (NSString *)labelText;

- (void)setLabelText:(NSString *)labelTextIn;

- (void)addObserver:(NSObject <AFFieldObserver> *)observer;

- (void)removeObserver:(NSObject <AFFieldObserver> *)observer;

/**
 *	This should be the targeted selector for the change events of any UI framework controls in this Settings cell
 */
- (void)controlValueChanged:(id)sender;

/**
 *	This should be implemented by a subclass to update the appearance of this Settings cell.
 *  This method will be called by subclasses of AFBaseField whenever their value property
 *  is changed.
 */
- (void)updateControlCell;

/**
 *	A default color to use for the cell background when this Settings value is deemed invalid by validator
 */
+ (UIColor *)validColor;

/**
 *	A default color to use for the cell background when this Settings value is deemed valid by validator
 */
+ (UIColor *)invalidColor;

@property(nonatomic, retain) NSObject <NSCoding> *value;
@property(nonatomic) BOOL valid;
@property(nonatomic, retain) NSString                                *identity;
@property(nonatomic, retain) NSString                                *helpText;
@property(nonatomic, retain) NSObject <AFValidator>                  *validator;
@property(nonatomic, retain) NSObject <AFFieldPersistenceDelegate> *persistenceDelegate;
@property(nonatomic, readonly) AFTableViewController                 *tableController;

@end
