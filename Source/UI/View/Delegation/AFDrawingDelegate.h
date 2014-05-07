//
// Created by Chris Hatton on 15/11/2012.
// Contact: christopherhattonuk@gmail.com
//

@class PAHierarchyObjectTableCellView;

@protocol AFDrawingDelegate <NSObject>

-(void) view:(UIView *)viewIn willMoveToWindow:(UIWindow*)windowIn;
-(void) drawRect:(CGRect)rectIn inView:(UIView *)viewIn;
-(void) layoutSubviewsInView:(UIView *)viewIn;

@end