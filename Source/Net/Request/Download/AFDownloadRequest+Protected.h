
#import <Foundation/Foundation.h>

@interface AFDownloadRequest (Protected)

-(void)beginPollSize:(AFRequestQueue *)queueIn;

-(void)didPollSize:(int)sizeIn;

@end