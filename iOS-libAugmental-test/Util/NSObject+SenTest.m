//
// Created by augmental on 25/01/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "NSObject+SenTest.h"

@implementation NSObject (SenTest)

-(void)failWithException:(NSException *)e
{
    printf("%s:%i: error: %s\n",
            [[[e userInfo] objectForKey:SenTestFilenameKey]    cStringUsingEncoding:NSUTF8StringEncoding],
            [[[e userInfo] objectForKey:SenTestLineNumberKey]  intValue],
            [[[e userInfo] objectForKey:SenTestDescriptionKey] cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end