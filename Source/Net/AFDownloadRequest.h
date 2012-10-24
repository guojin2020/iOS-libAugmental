
#import <Foundation/Foundation.h>
#import "AFQueueableRequest.h"
#import "AFBaseRequest.h"
#import "AFRequestEndpoint.h"

@class AFHeaderRequest;
@class AFSession;

@interface AFDownloadRequest : AFBaseRequest <AFQueueableRequest, AFRequestEndpoint>

+ (AFDownloadRequest *)requestForURL:(NSURL *)URLIn targetPath:(NSString *)targetPathIn observers:(NSSet *)observersIn fileSizeCache:(NSMutableDictionary *)sizeCacheIn;

+ (void)clearRequestPool;

+ (BOOL)sizePolledForAllPooledRequests;

- (id)initWithURL:(NSURL *)URLIn targetPath:(NSString *)targetPathIn observers:(NSSet *)observersIn fileSizeCache:(NSMutableDictionary *)sizeCacheIn;

- (void)updateReceivedBytesFromFile;

- (BOOL)existsInLocalStorage;

- (void)deleteLocalCopy;

- (void)closeHandleSafely;

@property(nonatomic, readonly) NSString *uniqueKey;
@property(nonatomic, readonly) NSString *targetPath;

@end
