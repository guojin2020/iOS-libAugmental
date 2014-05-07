//
// Created by augmental on 25/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFRequestObserver.h"

@interface TestDownloadRequestObserver : NSObject <AFRequestObserver>

-(id)initWithRequest:(AFRequest *)request
      callbackObject:(id)callbackObject
    callbackSelector:(SEL)selector;

@end