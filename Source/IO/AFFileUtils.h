//
// Created by augmental on 27/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>

@interface AFFileUtils : NSObject

+(bool)createAncestorDirectoriesForPath:(NSURL *)fileURL error:(NSError * *)error;

+(NSString *)downloadsDirectory;

@end