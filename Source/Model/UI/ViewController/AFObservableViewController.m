//
//  AFObservableViewController.m
//  iOS-libAugmental
//
//  Created by Chris Hatton on 31/07/2012.
//  Copyright (c) 2012 Chris Hatton. All rights reserved.
//

#import "AFObservableViewController.h"
#import "AFObservable.h"

@implementation AFObservableViewController

- (id)initWithObservable:(AFObservable *)objectIn
{
    if ((self = [self init]))
    {
        observableObject = objectIn;
    }
    return self;
}


- (AFObservable *)observableObject
{
    return observableObject;
}

@end
