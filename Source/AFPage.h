
#import <Foundation/Foundation.h>

@class AFPageManager;

@interface AFPage : NSObject
{
	NSString* title;
	UIViewController* viewController;
	AFPageManager* manager;
	
	UIBarButtonItem* nextBarButtonItem;
	UIBarButtonItem* previousBarButtonItem;
}

-(id)initWithViewController:(UIViewController*)viewControllerIn;

-(NSString*)pagePositionString;

-(BOOL)mayGoToNextStep;
-(BOOL)mayGoToPreviousStep;

-(BOOL)isRoot;
-(BOOL)isLast;

-(void)updateNavigationItems;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIBarButtonItem* nextBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem* previousBarButtonItem;
@property (nonatomic, retain) UIViewController* viewController;
@property (nonatomic, retain) AFPageManager* manager;

@end
