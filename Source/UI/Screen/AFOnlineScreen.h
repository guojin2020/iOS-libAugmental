#import <Foundation/Foundation.h>

#import "AFSessionObserver.h"
#import "AFScreen.h"
#import "AFPThemeable.h"

@interface AFOnlineScreen : AFScreen <AFSessionObserver, AFPThemeable>
{
    UIViewController *offlineViewController;
}

@end
