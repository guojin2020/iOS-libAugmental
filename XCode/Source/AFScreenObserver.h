
@class AFScreen;

/*
 * Protocol describing an Object which can respond to Screens being displayed or hidden
 */
@protocol AFScreenObserver

-(void)screenBecameInactive:(AFScreen*)screen;
-(void)screenBecameActive:(AFScreen*)screen;

@optional

-(void)screenViewControllerChanged:(AFScreen*)screen from:(UIViewController*)oldViewController;

@end
