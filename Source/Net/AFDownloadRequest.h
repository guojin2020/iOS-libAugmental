#import <Foundation/Foundation.h>
#import "AFQueueableRequest.h"
#import "AFBaseRequest.h"
#import "AFRequestEndpoint.h"

@class AFHeaderRequest;
@class AFSession;

@interface AFDownloadRequest : AFBaseRequest <AFQueueableRequest, AFRequestEndpoint>
{
    NSFileHandle        *myHandle;
    NSString            *targetPath;
    NSMutableDictionary *sizeCache;
    int queuePosition;
    NSString      *uniqueKey;
    NSMutableData *dataBuffer;
    int dataBufferPosition;
    AFHeaderRequest *pollSizeRequest;
}

+ (AFDownloadRequest *)requestForURL:(NSURL *)URLIn targetPath:(NSString *)targetPathIn observers:(NSSet *)observersIn fileSizeCache:(NSMutableDictionary *)sizeCacheIn;

+ (void)clearRequestPool;

+ (BOOL)sizePolledForAllPooledRequests;

- (id)initWithURL:(NSURL *)URLIn targetPath:(NSString *)targetPathIn observers:(NSSet *)observersIn fileSizeCache:(NSDictionary *)sizeCacheIn;

- (BOOL)complete;

//- (void)writeDataInternal:(NSData *)data;

- (void)updateReceivedBytesFromFile;

- (BOOL)existsInLocalStorage;

- (void)deleteLocalCopy;

- (void)closeHandleSafely;

@property(nonatomic, retain, readonly) NSString *uniqueKey;
@property(nonatomic, readonly) NSString *targetPath;

@end
