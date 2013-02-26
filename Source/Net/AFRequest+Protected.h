//
// Created by augmental on 26/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFRequest.h"

@interface AFRequest (Protected)

-(int)contentLengthFromHeader:(NSDictionary *)header;
-(bool)isSuccessHTTPResponse;
-(NSRange)contentRangeFromHeader:(NSDictionary *)header;

@property(nonatomic, readwrite) AFRequestState state;
@property(nonatomic, readwrite) int receivedBytes;
@property(nonatomic, readwrite) int expectedBytes;
@property(nonatomic, readwrite, retain) NSError* error;

@end