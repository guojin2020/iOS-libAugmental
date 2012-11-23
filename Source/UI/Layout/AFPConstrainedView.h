//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//


@protocol AFPConstrainedView <NSObject>

@property (nonatomic, readonly) CGSize preferredSize;
@property (nonatomic, readonly) CGSize minimumSize;
@property (nonatomic, readonly) CGSize maximumSize;

@end