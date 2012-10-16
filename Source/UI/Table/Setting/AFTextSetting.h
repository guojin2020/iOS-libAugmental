#import <Foundation/Foundation.h>
#import "AFBaseSetting.h"
#import "AFSetting.h"
#import "AFThemeable.h"

#define THEME_KEY_TEXT_COLOR            @"textColor"
#define THEME_KEY_BEGIN_EDITING_SOUND    @"beginEditingSound"

@protocol AFSettingPersistenceDelegate;

@interface AFTextSetting : AFBaseSetting <UITextFieldDelegate, AFSetting, AFThemeable>
{
    UITextField                    *textField;
    NSObject <UITextFieldDelegate> *textFieldDelegate;
    uint8_t maxLength;

}

+ (UIColor *)textColor;

+ (NSString *)beginEditingSound;

@property(nonatomic, retain) NSString                       *string;
@property(nonatomic, retain) UITextField                    *textField;
@property(nonatomic, retain) NSObject <UITextFieldDelegate> *textFieldDelegate;
@property(nonatomic) uint8_t maxLength;

@end
