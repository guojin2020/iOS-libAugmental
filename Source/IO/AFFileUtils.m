//
// Created by augmental on 27/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AFFileUtils.h"
#import "AFLog.h"

@implementation AFFileUtils

+(bool)createAncestorDirectoriesForPath:(NSURL*)fileURL error:(NSError**)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDirectory = NO;
    NSString* directoryPath = [[fileURL URLByDeletingLastPathComponent] path];
    if(![fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory])
    {
        AFLog(@"Creating directory: %@", directoryPath);
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:error];
        return YES;
    }
    else return NO;
}

+(NSString *)downloadsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

@end