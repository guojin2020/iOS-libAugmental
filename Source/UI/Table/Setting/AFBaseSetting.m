#import "AFBaseSetting.h"
#import "AFValidator.h"
#import "AFTable.h"
#import "AFTableViewController.h"
#import "AFThemeManager.h"

@implementation AFBaseSetting

static UIColor *validColor   = nil;
static UIColor *invalidColor = nil;

- (id)initWithIdentity:(NSString *)identityIn persistenceDelegate:(NSObject <AFSettingPersistenceDelegate> *)persistenceDelegateIn defaultValue:(NSObject <NSCoding> *)defaultValue
{
    if ((self = [self initWithIdentity:identityIn]))
    {
        self.persistenceDelegate = persistenceDelegateIn;
        NSData *persistedData = [persistenceDelegate restoreSettingValueForKey:identity];
        if (persistedData)
        {
            //NSLog(@"%@ with key '%@' is being set by persisted data using %@",NSStringFromClass([self class]),identity,NSStringFromClass([persistenceDelegate class]));
            self.value = [NSKeyedUnarchiver unarchiveObjectWithData:persistedData];
        }
        else self.value = defaultValue;
    }
    return self;
}

- (id)initWithIdentity:(NSString *)identityIn
{
    if ((self = [super init]))
    {
        self.identity            = identityIn;
        self.persistenceDelegate = nil;
        self.validator           = nil;

        settingObservers = [[NSMutableSet alloc] init];
        cell = nil;
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

    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    cell.textLabel.opaque            = NO;
    cell.textLabel.backgroundColor   = [UIColor clearColor];
    cell.contentView.opaque          = NO;
    cell.contentView.backgroundColor = [UIColor clearColor];

    [self updateControlCell];
}


- (NSString *)labelText
{return labelText;}

- (void)setLabelText:(NSString *)labelTextIn
{
    NSString *oldLabelText = labelText;
    labelText = [labelTextIn retain];
    [oldLabelText release];
    if (cell)[[cell textLabel] setText:labelText];
}

- (void)addObserver:(NSObject <AFSettingObserver> *)observer
{[settingObservers addObject:observer];}

- (void)removeObserver:(NSObject <AFSettingObserver> *)observer
{[settingObservers removeObject:observer];}


- (void)controlValueChanged:(id)sender
{[self doesNotRecognizeSelector:_cmd];}

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
        //Do the Release/Retain dance with the new value
        NSObject *oldValue = value;
        value              = [valueIn retain];
        [oldValue release];

        for (NSObject <AFSettingObserver> *observer in settingObservers)
        {[observer settingChanged:(NSObject <AFSetting> *) self];}

        [self updateControlCell];
    }
    else
    {
    }
}

/**
 * This method should refresh the appearance of the UI table cell for this setting.
 * In AFBaseSetting this only sets the background color of the cell based on validation.
 * Should be subclassed to implement display of the settings value.
 */
- (void)updateControlCell
{
    [self setFillColor:[self valid] ? [AFBaseSetting validColor] : [AFBaseSetting invalidColor]];
}

/**
 This method implements the AFEventObserver protocol, meaning that when
 the application exits, this settings value will be persisted using its persistence
 delegate.
 */
- (void)eventOccurred:(event)type source:(NSObject *)source
{
    switch (type)
    {
        case (event) APP_TERMINATING:
            //NSLog(@"%@ with key '%@' is persisting its value data using %@",NSStringFromClass([self class]),identity,NSStringFromClass([persistenceDelegate class]));
            [persistenceDelegate persistSettingValue:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:identity];
            break;
        case (event) OBJECT_FIELD_UPDATED:
            valueChangedSinceLastValidation = YES;
            [self updateControlCell];
            break;
        default:
            break;
    }
}

/**
 This method is called by the AFTable framework when the cell is selected.
 As a default behaviour it will cause a UIAlert box to appear, displaying any help
 text associated with this Setting.
 This behaviour may be over-ridden by a subclass e.g. to display a more detailed view, or alternative
 actions that may be taken on the setting.
 */
- (void)cellSelected:(AFTableCell *)object
{
    if ([helpText isKindOfClass:[NSString class]] && [helpText length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:labelText message:[self helpText] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (NSObject <AFValidator> *)validator
{return validator;}

- (void)setValidator:(NSObject <AFValidator> *)newValidator
{
    NSObject <AFValidator> *oldValidator = validator;
    validator = [newValidator retain];
    [oldValidator release];
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
    {validColor = [[[AFThemeManager themeSectionForClass:[AFBaseSetting class]] colorForKey:THEME_KEY_VALID_COLOR] retain];}
    return validColor;
}

+ (UIColor *)invalidColor
{
    if (!invalidColor)
    {invalidColor = [[[AFThemeManager themeSectionForClass:[AFBaseSetting class]] colorForKey:THEME_KEY_INVALID_COLOR] retain];}
    return invalidColor;
}

//====>> Themeable

- (void)themeChanged
{
    validColor   = nil;
    invalidColor = nil;
}

+ (Class <AFThemeable>)themeParentSectionClass
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

- (void)dealloc
{
    //[[AFAppDelegate appEventManager] removeObserver:self];
    [labelText release];
    [settingObservers release];
    [cell release];
    [identity release];
    [validator release];
    [value release];
    [value release];
    [validator release];
    [validator release];
    [value release];
    [value release];
    [validator release];
    [value release];
    [validator release];
    [value release];
    [value release];
    [validator release];
    [validator release];
    [persistenceDelegate release];
    [helpText release];
    [value release];
    [validator release];
    [super dealloc];
}

@synthesize persistenceDelegate, identity, helpText, value, validator, valid, tableController;

@end
