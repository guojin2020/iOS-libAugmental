
#import <Foundation/Foundation.h>

#import "AFRequest.h"

#import "AFRequestEndpoint.h"
#import "AFPDownloadRequest.h"

@class AFHeaderRequest;
@class AFSession;
@class AFRequestQueue;
@class AFDefaultsBackedStringDictionary;

@protocol AFPDownloadable;

@interface AFDownloadRequest : AFRequest <AFRequestEndpoint, UIAlertViewDelegate, AFPDownloadRequest>
{
	AFRequest* pollSizeRequest;
	AFDefaultsBackedStringDictionary *expectedSizeCache;
}

-(id)initWithDownloadable:(id<AFPDownloadable>)downloadableIn
                observers:(NSSet *)observersIn
            fileSizeCache:(NSMutableDictionary *)sizeCacheIn
requestQueueForHeaderPoll:(AFRequestQueue *)queueIn;

-(id)initWithURL:(NSURL *)urlIn
      targetPath:(NSString *)targetPathIn
       observers:(NSSet *)observersIn
            fileSizeCache:(NSMutableDictionary *)sizeCacheIn
requestQueueForHeaderPoll:(AFRequestQueue *)queueIn;

-(BOOL)existsInLocalStorage;

-(void)deleteLocalFile;

-(void)closeHandleSafely;

@property(nonatomic, readonly) NSString *localFilePath;
//@property(nonatomic, retain) AFRequest* pollSizeRequest;

@end
