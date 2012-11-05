//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFSKProductFetchResponse.h"


@interface AFSKProductFetchResponseFailed : AFSKProductFetchResponse

-(id)initWithReason:(NSString *)reason;

@property (nonatomic, readonly) NSString* reason;

@end