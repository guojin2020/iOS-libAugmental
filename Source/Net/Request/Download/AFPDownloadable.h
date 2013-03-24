//
// Created by augmental on 23/03/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol AFPDownloadable <NSObject>

-(NSString*)remoteIdentifier;
-(NSString*)localFilePath;

@end