#import <Foundation/Foundation.h>

#import "AFViewPanelField.h"

@interface AFStringListField : AFViewPanelField
{
}

- (id)initWithIdentity:(NSString *)identityIn
                 title:(NSString *)titleIn
            stringList:(NSArray *)stringListIn
             labelIcon:(UIImage *)icon;

@end
