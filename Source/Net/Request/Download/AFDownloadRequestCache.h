
#import <Foundation/Foundation.h>

@class AFDownloadRequest;
@class AFRequestQueue;

@protocol AFPDownloadable;
@protocol AFPDownloadRequest;

@interface AFDownloadRequestCache : NSObject

+(AFDownloadRequestCache *)defaultCache;

-(AFDownloadRequest *)requestForDownloadable:(NSObject<AFPDownloadable>*) downloadableIn
                                   observers:(NSSet*)                     observersIn
                       queueForHeaderRequest:(AFRequestQueue*)            queueIn;

- (void)addDownloadRequestClass:(Class <AFPDownloadRequest>)downloadRequestClass
           forDownloadableClass:(Class <AFPDownloadable>)downloadableClass;

-(void)clear;

-(BOOL)sizePolledForAllCachedRequests;

@end