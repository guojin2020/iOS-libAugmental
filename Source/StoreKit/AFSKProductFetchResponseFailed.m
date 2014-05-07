//
// Created by Chris Hatton on 04/11/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFSKProductFetchResponseFailed.h"

@implementation AFSKProductFetchResponseFailed
{
    NSString* reason;
}
- (id)initWithReason:(NSString *)reasonIn
{
    self = [self init];
    if(self)
    {
        reason = reasonIn;
    }
    return self;
}

-(NSString*)reason
{
    return reason;
}


@end