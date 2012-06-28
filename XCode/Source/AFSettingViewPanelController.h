
#import <Foundation/Foundation.h>
@protocol AFSettingViewPanelObserver;

@interface AFSettingViewPanelController : UIViewController
{
	NSMutableSet* observers;
	NSObject<NSCoding>* value;
	NSObject<NSCoding>* defaultValue;
	
	UIView* loadingView;
}

-(id)initWithObserver:(NSObject<AFSettingViewPanelObserver>*)observerIn
			  nibName:(NSString*)nibNameIn
			   bundle:(NSBundle*)bundleIn;

-(id)initWithObservers:(NSSet*)initialObservers
			   nibName:(NSString*)nibNameIn
				bundle:(NSBundle*)bundleIn;

-(void)addObserver:(NSObject<AFSettingViewPanelObserver>*)observerIn;
-(void)removeObserver:(NSObject<AFSettingViewPanelObserver>*)observerIn;

-(void)broadcastNewValueToObservers:(NSObject*)newValue;

@property (nonatomic, retain) NSSet* observers;
@property (nonatomic, retain) NSObject<NSCoding>* value;
@property (nonatomic, retain) NSObject<NSCoding>* defaultValue;

@property (nonatomic,retain) IBOutlet UILabel* loadingLabel;
@property (nonatomic,retain) IBOutlet UIView* loadingView;

@end
