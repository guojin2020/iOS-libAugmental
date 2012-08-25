#import <Foundation/Foundation.h>

#import "AFSessionObserver.h"
#import "AFScreen.h"
#import "AFThemeable.h"

@interface AFOnlineScreen : AFScreen <AFSessionObserver, AFThemeable>
{
    UIViewController *offlineViewController;
}

@end
