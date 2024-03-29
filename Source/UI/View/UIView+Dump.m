
#import "UIView+Dump.h"
#import "AFLog.h"

@implementation UIView (Dump)

-(void)dump
{
    [self dumpWithText:@"" indent:@""];
}

-(void)dumpWithText:(NSString *)text indent:(NSString *)indent
{
    Class cl = [self class];
    NSString *classDescription = [cl description];
    while ([cl superclass])
    {
        cl = [cl superclass];
        classDescription = [classDescription stringByAppendingFormat:@":%@", [cl description]];
    }

    if ([text compare:@""] == NSOrderedSame)
    {
        AFLog(@"%@ %@", classDescription, NSStringFromCGRect(self.frame));
    }
    else
    {
        AFLog(@"%@ %@ %@", text, classDescription, NSStringFromCGRect(self.frame));
    }

    for (NSUInteger i = 0; i < [self.subviews count]; i++)
    {
        UIView *subView = (self.subviews)[i];
        NSString *newIndent = [[NSString alloc] initWithFormat:@"  %@", indent];
        NSString *msg = [[NSString alloc] initWithFormat:@"%@%d:", newIndent, i];
        [subView dumpWithText:msg indent:newIndent];
    }
}

@end