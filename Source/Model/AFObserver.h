
#import <Foundation/Foundation.h>

@class AFObservable;

@protocol AFObserver

@optional
-(void)atomicChangeWillBegin:(AFObservable*)observableIn;
-(void)atomicChangeDidFinish:(AFObservable*)observableIn;

@end