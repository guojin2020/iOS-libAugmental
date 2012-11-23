//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
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