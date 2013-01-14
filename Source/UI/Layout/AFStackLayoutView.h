//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//


#import <Foundation/Foundation.h>
#import "AFLayoutView.h"


@interface AFStackLayoutView : AFLayoutView
{
    bool fillsRemainder;
}

-(id)initWithRemainderFill:(BOOL)fillsRemainderIn;

@end