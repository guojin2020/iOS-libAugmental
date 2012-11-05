//
// Created by augmental on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
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