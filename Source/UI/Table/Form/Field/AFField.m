#import "AFField.h"
#import "AFValidator.h"
#import "AFTable.h"
#import "AFTableViewController.h"
#import "AFThemeManager.h"
#import "AFObject.h"
#import "AFLog.h"

@implementation AFField

static UIColor *validColor   = nil;
static UIColor *invalidColor = nil;

- (id)initWithIdentity:(NSString *)identityIn persistenceDelegate:(NSObject <AFFieldPersistenceDelegate> *)persistenceDelegateIn defaultValue:(NSObject <NSCoding> *)defaultValue
{
    if ((self = [self initWithIdentity:identityIn]))
    {
        self.persistenceDelegate = persistenceDelegateIn;
        NSData *persistedData = [persistenceDelegate restoreSettingValueForKey:identity];
        if (persistedData)
        {
            //AFLog(@"%@ with key '%@' is being set by persisted data using %@",NSStringFromClass([self class]),identity,NSStringFromClass([persistenceDelegate class]));
            self.value = [NSKeyedUnarchiver unarchiveObjectWithData:persistedData];
        }
        else self.value = defaultValue;
    }
    return self;
}

- (id)initWithIdentity:(NSString *)identityIn
{
    if ((self = [self init]))
    {
        self.identity            = identityIn;
        self.persistenceDelegate = nil;
        self.validator           = nil;

        settingObservers = [[NSMutableSet alloc] init];

        [self setLabelText:identity];

        [persistenceDelegate restoreSettingValueForKey:identity];
        //[[AFAppDelegate appEventManager] addObserver:self];
        helpText = nil;

        lastValidationResult            = NO;
        valueChangedSinceLastValidation = YES;

        [self setSelectionDelegate:self];
        value = nil;
    }
    return self;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    self.viewCell.textLabel.numberOfLines = 2;
    self.viewCell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.viewCell.textLabel.textAlignment = NSTextAlignmentCenter;

    self.viewCell.textLabel.opaque            = NO;
    self.viewCell.textLabel.backgroundColor   = [UIColor clearColor];
    self.viewCell.contentView.opaque          = NO;
    self.viewCell.contentView.backgroundColor = [UIColor clearColor];

    [self updateControlCell];
}

- (void)setLabelText:(NSString *)labelTextIn
{
    self.labelText = labelTextIn;
    if (self.viewCell)[[self.viewCell textLabel] setText:self.labelText];
}

- (void)addObserver:(NSObject <AFFieldObserver> *)observer
{
    [settingObservers addObject:observer];
}

- (void)removeObserver:(NSObject <AFFieldObserver> *)observer
{
    [settingObservers removeObject:observer];
}

- (void)controlValueChanged:(id)sender
{
    [self doesNotRecognizeSelector:_cmd];
}

/**
 * Sets this Settings value. If the given value is the same as the current value, no action is taken.
 * If the given value is different, the Settings value is updated, its observers are sent the settingChanged: message,
 * and the updateControlCell is called.
 */
- (void)setValue:(NSObject <NSCoding> *)valueIn
{
    valueChangedSinceLastValidation = YES; //Keep this outside conditional; it's only an optimisation to prevent repeated calculation of validation, but woudl cause problems if you were re-setting the same pointer to indicate a change in the pointed-to object.
    if (value != valueIn)
    {
        value              = valueIn;

        for (NSObject <AFFieldObserver> *observer in settingObservers)
        {[observer settingChanged:(AFField*) self];}

        [self updateControlCell];
    }
    else
    {
    }
}

/**
 * This method should refresh the appearance of the UI table _viewCell for this setting.
 * In AFField this only sets the background color of the _viewCell based on validation.
 * Should be subclassed to implement display of the settings value.
 */
- (void)updateControlCell
{
    [self setFillColor:[self valid] ? [AFField validColor] : [AFField invalidColor]];
}

-(void)handleObjectFieldUpdated:(AFObject*)objectIn
{
    AFLogPosition();

    valueChangedSinceLastValidation = YES;
    [self updateControlCell];
}

-(void)handleAppTerminating
{
    AFLogPosition();

    [persistenceDelegate persistFieldValue:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:identity];
}

/**
 This method is called by the AFTable framework when the _viewCell is selected.
 As a default behaviour it will cause a UIAlert box to appear, displaying any help
 text associated with this Setting.
 This behaviour may be over-ridden by a subclass e.g. to display a more detailed view, or alternative
 actions that may be taken on the setting.
 */
- (void)cellSelected:(AFTableCell *)object
{
    if ([helpText isKindOfClass:[NSString class]] && [helpText length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.labelText message:[self helpText] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (NSObject <AFValidator> *)validator
{return validator;}

- (void)setValidator:(NSObject <AFValidator> *)newValidator
{
    validator = newValidator;
    self.value = value;
}

- (BOOL)valid
{
    if (!validator) return YES;
    else if (valueChangedSinceLastValidation)
    {
        lastValidationResult            = [validator isValid:self.value];
        valueChangedSinceLastValidation = NO;
    }
    return lastValidationResult;
}

- (AFTableViewController *)tableController
{
    return self.parentSection.parentTable.viewController;
}

+ (UIColor *)validColor
{
    if (!validColor)
    {validColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFField class]] colorForKey:THEME_KEY_VALID_COLOR];}
    return validColor;
}

+ (UIColor *)invalidColor
{
    if (!invalidColor)
    {invalidColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFField class]] colorForKey:THEME_KEY_INVALID_COLOR];}
    return invalidColor;
}

//====>> Themeable

- (void)themeChanged
{
    validColor   = nil;
    invalidColor = nil;
}

+ (id<AFPThemeable>)themeParentSectionClass
{return nil;}

+ (NSString *)themeSectionName
{return @"setting";}

+ (NSDictionary *)defaultThemeSection
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"FFFFFF", THEME_KEY_VALID_COLOR,
            @"B83030", THEME_KEY_INVALID_COLOR,
            nil];
}

//====>> Dealloc


@synthesize persistenceDelegate, identity, helpText, value, valid;

@end
