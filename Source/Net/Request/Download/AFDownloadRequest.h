
#import <Foundation/Foundation.h>

#import "AFRequest.h"
#import "AFRequestEndpoint.h"
#import "AFPDownloadRequest.h"

@class AFHeaderRequest;
@class AFSession;
@class AFRequestQueue;

@protocol AFPDownloadable;

@interface AFDownloadRequest : AFRequest <AFRequestEndpoint, UIAlertViewDelegate, AFPDownloadRequest>

-(id)initWithDownloadable:(id<AFPDownloadable>)downloadableIn
                observers:(NSSet *)observersIn
            fileSizeCache:(NSMutableDictionary *)sizeCacheIn
requestQueueForHeaderPoll:(AFRequestQueue *)queueIn;

-(id)initWithURL:(NSString *)remoteIdentifierIn
      targetPath:(NSString *)targetPathIn
       observers:(NSSet *)observersIn
            fileSizeCache:(NSMutableDictionary *)sizeCacheIn
requestQueueForHeaderPoll:(AFRequestQueue *)queueIn;

-(BOOL)existsInLocalStorage;

-(void)deleteLocalFile;

-(void)closeHandleSafely;

@property(nonatomic, readonly) NSString *localFilePath;

@end
