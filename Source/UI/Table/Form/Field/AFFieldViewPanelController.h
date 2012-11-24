#import <Foundation/Foundation.h>

@protocol AFFieldViewPanelObserver;

@interface AFFieldViewPanelController : UIViewController
{
    NSMutableSet        *observers;
    NSObject <NSCoding> *value;
    NSObject <NSCoding> *defaultValue;

    UIView *loadingView;
}

- (id)initWithObserver:(NSObject <AFFieldViewPanelObserver> *)observerIn
               nibName:(NSString *)nibNameIn
                bundle:(NSBundle *)bundleIn;

- (id)initWithObservers:(NSSet *)initialObservers
                nibName:(NSString *)nibNameIn
                 bundle:(NSBundle *)bundleIn;

- (void)addObserver:(NSObject <AFFieldViewPanelObserver> *)observerIn;

- (void)removeObserver:(NSObject <AFFieldViewPanelObserver> *)observerIn;

- (void)broadcastNewValueToObservers:(NSObject *)newValue;

@property(nonatomic, retain) NSMutableSet        *observers;
@property(nonatomic, retain) NSObject <NSCoding> *value;
@property(nonatomic, retain) NSObject <NSCoding> *defaultValue;

@property(nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property(nonatomic, retain) IBOutlet UIView  *loadingView;

@end
