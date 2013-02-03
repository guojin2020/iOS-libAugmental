
#import <Foundation/Foundation.h>

#import "AFRequest.h"
#import "AFRequestEndpoint.h"

@class AFHeaderRequest;
@class AFSession;
@class AFRequestQueue;

@interface AFDownloadRequest : AFRequest <AFRequestEndpoint, UIAlertViewDelegate>

+ (AFDownloadRequest *)requestForURL:(NSURL *)URLIn localFilePath:(NSString *)localFilePathIn observers:(NSSet *)observersIn fileSizeCache:(NSMutableDictionary *)sizeCacheIn queueForHeaderRequest:(AFRequestQueue *)queueIn;

+ (void)clearRequestPool;

+ (BOOL)sizePolledForAllPooledRequests;

- (id)initWithURL:(NSURL *)URLIn targetPath:(NSString *)targetPathIn observers:(NSSet *)observersIn fileSizeCache:(NSMutableDictionary *)sizeCacheIn requestQueueForHeaderPoll:(AFRequestQueue *)queueIn;

- (BOOL)existsInLocalStorage;

- (void)deleteLocalFile;

- (void)closeHandleSafely;

@property(nonatomic, readonly) NSString *localFilePath;

@end
