#import "AFTextField.h"
#import "AFAppDelegate.h"
#import "AFTable.h"
#import "AFThemeManager.h"
#import "AFTableViewController.h"

static UIColor  *textColor         = nil;
static NSString *beginEditingSound = nil;

@implementation AFTextField

- (id)initWithIdentity:(NSString *)identityIn
{
    if ((self = [super initWithIdentity:identityIn]))
    {
        textFieldDelegate = nil;

        textField = [[UITextField alloc] init];
        textField.placeholder              = (NSString *) value;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.textColor                = [UIColor blackColor];
        textField.font                     = [UIFont systemFontOfSize:14.0];
        textField.textAlignment            = NSTextAlignmentCenter;
        textField.borderStyle              = UITextBorderStyleRoundedRect;
        textField.autocorrectionType       = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.keyboardType    = UIKeyboardTypeDefault;
        textField.returnKeyType   = UIReturnKeyDefault;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;

        if (value) textField.text = (NSString *) value;
    }
    return self;
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];

    [self.viewCell setAccessoryView:textField];

    CGRect textFieldFrame = CGRectMake(100.0, 15.0, 180, 36.0);
    self.viewCell.accessoryView.frame = textFieldFrame;
    //_viewCell.accessoryView.transform = CGAffineTransformMakeTranslation(0, 15);

    self.viewCell.selectionStyle = UITableViewCellSelectionStyleGray;

    [self updateControlCell];
}

//======>>  UITextFieldDelegate Implementation

- (BOOL)textField:(UITextField *)textFieldIn shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)stringIn
{
    return !(maxLength > 0 && [textFieldIn.text length] >= maxLength && range.length == 0);
}

- (void)textFieldDidBeginEditing:(UITextField *)textFieldIn
{
    [AFAppDelegate playSound:[AFTextField beginEditingSound]];

    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:self.viewCell] atScrollPosition:UITableViewScrollPositionNone animated:YES];

    [self.parentSection.parentTable.viewController textFieldDidBeginEditing:textFieldIn];
    if (textFieldDelegate) [textFieldDelegate textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textFieldIn
{
    [self.parentSection.parentTable.viewController textFieldDidEndEditing:textFieldIn];
    if (textFieldDelegate) [textFieldDelegate textFieldDidEndEditing:textFieldIn];
}

- (BOOL)textFieldShouldClear:(UITextField *)textFieldIn
{return YES;}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textFieldIn
{return YES;}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldIn
{
    [textFieldIn resignFirstResponder];
    return NO;
}

- (void)updateControlCell
{
    [super updateControlCell];
    if (![(NSString *) value isEqualToString:[textField text]])[textField setText:(NSString *) value];
}

- (void)controlValueChanged:(id)sender
{
    if (sender == textField) [self setValue:[textField text]];
}

//============>> Theme property getters

+ (UIColor *)textColor
{
    if (!textColor)textColor = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTextField class]] colorForKey:THEME_KEY_TEXT_COLOR];
    return textColor;
}

+ (NSString *)beginEditingSound
{
    if (!beginEditingSound)beginEditingSound = [[AFThemeManager themeSectionForClass:(id<AFPThemeable>)[AFTextField class]] valueForKey:THEME_KEY_BEGIN_EDITING_SOUND];
    return beginEditingSound;
}

//============>> Themeable

- (void)themeChanged
{
    textColor         = nil;
    beginEditingSound = nil;
}

+ (id<AFPThemeable>)themeParentSectionClass
{return nil;}

+ (NSString *)themeSectionName
{return @"textSetting";}

+ (NSDictionary *)defaultThemeSection
{
    return @{THEME_KEY_TEXT_COLOR: @"000000",
            THEME_KEY_BEGIN_EDITING_SOUND: @"beep-21"};
}

//============>> Dealloc


@synthesize string, textField, textFieldDelegate, maxLength;

//@dynamic value, valid;

@end
