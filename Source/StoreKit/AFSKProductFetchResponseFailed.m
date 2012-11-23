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
    self = [super init];
    if(self)
    {
        reason = [reasonIn retain];
    }
    return self;
}

-(NSString*)reason
{
    return reason;
}

- (void)dealloc
{
    [reason release];
    [super dealloc];
}

@end