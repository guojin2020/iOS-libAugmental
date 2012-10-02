//
// Created by darkmoon on 29/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFPConstrainedView.h"

@interface AFConstrainedView : UIView <AFPConstrainedView>
{
    CGSize
        _preferredSize,
        _minimumSize,
        _maximumSize;

    UIEdgeInsets _edgeInsets;
}

@property (nonatomic) CGSize preferredSize;
@property (nonatomic) CGSize minimumSize;
@property (nonatomic) CGSize maximumSize;

@end