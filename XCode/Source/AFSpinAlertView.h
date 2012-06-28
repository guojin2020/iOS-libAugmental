#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFSpinAlertView : UIAlertView
{
	UIActivityIndicatorView *indicator;
}

-(id)initWithTitle:(NSString*)titleIn message:(NSString*)messageIn;
-(void)dismiss;

@end
