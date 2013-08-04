#import <Foundation/Foundation.h>

#import "AFField.h"
#import "AFPThemeable.h"

#define THEME_KEY_TEXT_COLOR            @"textColor"
#define THEME_KEY_BEGIN_EDITING_SOUND    @"beginEditingSound"

@protocol AFFieldPersistenceDelegate;

@interface AFTextField : AFField <UITextFieldDelegate, AFPThemeable>
{
    UITextField                    *textField;
    NSObject <UITextFieldDelegate> *textFieldDelegate;
    uint8_t maxLength;

}

+ (UIColor *)textColor;

+ (NSString *)beginEditingSound;

@property(nonatomic, strong) NSString                       *string;
@property(nonatomic, strong) UITextField                    *textField;
@property(nonatomic, strong) NSObject <UITextFieldDelegate> *textFieldDelegate;
@property(nonatomic) uint8_t maxLength;

@end
