//
// Created by darkmoon on 29/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "AFPConstrainedView.h"

@interface AFConstrainedView : UIView <AFPConstrainedView>
{
    CGSize _preferredSize;
    CGSize _minimumSize;
}

@property (nonatomic, assign) CGSize preferredSize;
@property (nonatomic, assign) CGSize minimumSize;

@end