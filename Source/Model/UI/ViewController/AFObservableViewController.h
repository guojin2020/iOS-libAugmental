//
//  AFObservableViewController.h
//  iOS-libAugmental
//
//  Created by Chris Hatton on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFObservable;

@interface AFObservableViewController : UIViewController
{
    AFObservable *object;
}

- (id)initWithObservable:(AFObservable *)objectIn;

@property(nonatomic, readonly) AFObservable *observableObject;

@end
