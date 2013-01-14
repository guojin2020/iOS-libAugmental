//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>
#import "AFPConstrainedView.h"

@interface AFConstrainedView : UIView <AFPConstrainedView>
{
    CGSize
        preferredSize,
        minimumSize,
        maximumSize;

    //UIEdgeInsets edgeInsets;
}

@property (nonatomic) CGSize preferredSize;
@property (nonatomic) CGSize minimumSize;
@property (nonatomic) CGSize maximumSize;

@end