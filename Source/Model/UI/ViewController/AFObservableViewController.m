//
//  AFObservableViewController.m
//  iOS-libAugmental
//
//  Created by Chris Hatton on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFObservableViewController.h"
#import "AFObservable.h"

@implementation AFObservableViewController

- (id)initWithObservable:(AFObservable *)objectIn
{
    if ((self = [self init]))
    {
        object = [objectIn retain];
    }
    return self;
}

- (void)dealloc
{
    [object release];
    [super dealloc];
}

- (AFObservable *)observableObject
{return object;}

@end
