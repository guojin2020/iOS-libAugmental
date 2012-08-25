#import <UIKit/UIKit.h>

@protocol AFValidatable

- (BOOL)valid;

@optional

- (BOOL)validateWithInvalidUserAlert;

@property(nonatomic, readonly) BOOL valid;

@end
