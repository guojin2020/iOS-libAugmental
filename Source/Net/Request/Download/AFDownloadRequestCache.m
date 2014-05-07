
#import "AFDownloadRequestCache.h"
#import "AFDownloadRequest.h"
#import "AFRequestObserver.h"
#import "AFRequestQueue.h"
#import "AFPDownloadable.h"
#import "AFDefaultsBackedStringDictionary.h"

#define FILE_SIZE_CACHE_KEY @"FileSizes"

static AFDownloadRequestCache *defaultCache = NULL;

@interface AFDownloadRequestCache ()

-(Class<AFPDownloadRequest>) downloadRequestClassForDownloadable:(NSObject <AFPDownloadable> *)downloadableIn;

@end

@implementation AFDownloadRequestCache
{
    NSMutableDictionary              *typeMap;
    NSMutableDictionary              *requestCache;
    AFDefaultsBackedStringDictionary *fileSizeCache;
}

+(AFDownloadRequestCache*)defaultCache
{
    return defaultCache ?: (defaultCache = [AFDownloadRequestCache new]);
}

-(id)init
{
    self = [super init];
    if(self)
    {
        typeMap       = [NSMutableDictionary new];
        requestCache  = [NSMutableDictionary new];
        fileSizeCache = [[AFDefaultsBackedStringDictionary alloc] initWithDefaultsKey:FILE_SIZE_CACHE_KEY];
    }
    return self;
}

-(void)addDownloadRequestClass:(Class<AFPDownloadRequest>)downloadRequestClass
          forDownloadableClass:(Class<AFPDownloadable>)downloadableClass
{
    NSString
        *downloadRequestClassName = NSStringFromClass(downloadRequestClass),
        *downloadableClassName    = NSStringFromClass(downloadableClass);

    [typeMap setValue:downloadRequestClassName forKey:downloadableClassName];
}

-(Class<AFPDownloadRequest>)downloadRequestClassForDownloadable:(NSObject<AFPDownloadable>*)downloadableIn
{
    NSString *downloadableClassName = NSStringFromClass([downloadableIn class]);
    for(NSString* className in [typeMap allKeys])
    {
        if([className isEqualToString:downloadableClassName])
        {
            NSString* downloadRequestClassName = [typeMap objectForKey:className];
            Class<AFPDownloadRequest> downloadableRequestClass = NSClassFromString(downloadRequestClassName);
            return downloadableRequestClass;
        }
    }
    return NULL;
}

-(AFDownloadRequest *)requestForDownloadable:(NSObject<AFPDownloadable>*) downloadableIn
                                   observers:(NSSet*)                     observersIn
                       queueForHeaderRequest:(AFRequestQueue*)            queueIn
{
    NSAssert( downloadableIn!=nil,  @"Downloadable must not be nil" );

    NSString *localFilePath = downloadableIn.localFilePath;

    AFDownloadRequest *request = [requestCache objectForKey:localFilePath];

    if( request ) // If there is already a cached request for that file, just observe it
    {
        for( NSObject<AFRequestObserver>* observer in observersIn ) [request addObserver:observer];
    }
    else // Otherwise, create a new request and requestCache it
    {
        Class requestClass = [self downloadRequestClassForDownloadable:downloadableIn];

        request = [requestClass alloc];

        SEL initWithDownloadableSelector = [(id<AFPDownloadRequest>)requestClass initWithDownloadableSelector];

        typedef void (*InitWithDownloadableMethod)(id, SEL, NSObject<AFPDownloadable>*, NSSet*, AFDefaultsBackedStringDictionary*, AFRequestQueue*);
        InitWithDownloadableMethod methodToCall;
        methodToCall = (InitWithDownloadableMethod)[request methodForSelector:initWithDownloadableSelector];
        methodToCall(request, initWithDownloadableSelector, downloadableIn, observersIn, fileSizeCache, queueIn);

        [requestCache setObject:request forKey:request.localFilePath];

    }

    return request;
}

-(void)clear { [requestCache removeAllObjects]; }

-(BOOL)sizePolledForAllCachedRequests
{
    @synchronized (requestCache)
    {
        for (NSString *curRequestKey in requestCache)
        {
            if( ((AFDownloadRequest *) [requestCache objectForKey:curRequestKey] ).expectedBytes == -1 )
            {
                return NO;
            }
        }
    }
    return YES;
}


@end