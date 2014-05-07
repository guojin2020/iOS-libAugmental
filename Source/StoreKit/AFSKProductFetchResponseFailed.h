//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>
#import "AFSKProductFetchResponse.h"


@interface AFSKProductFetchResponseFailed : AFSKProductFetchResponse

-(id)initWithReason:(NSString *)reason;

@property (weak, nonatomic, readonly) NSString* reason;

@end