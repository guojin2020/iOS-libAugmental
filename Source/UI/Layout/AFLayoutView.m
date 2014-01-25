//
// Created by darkmoon on 29/08/2012.
// Contact: christopherhattonuk@gmail.com
//

#import "AFLayoutView.h"
#import "UIView+Order.h"

@implementation AFLayoutView
{
    UIView* _backgroundView;
    NSMutableSet* _subviewsExcludedFromLayout;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.edgeInsets = UIEdgeInsetsZero;
        _subviewsExcludedFromLayout = [NSMutableSet new];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [_backgroundView sendToBack];
    _backgroundView.frame = self.bounds;
}

- (UIView *)backgroundView { return _backgroundView; }

- (void)setBackgroundView:(UIView *)backgroundView
{
    if(backgroundView!=_backgroundView)
    {
        [_backgroundView removeFromSuperview];
        if(_backgroundView)[self setSubview:_backgroundView excludedFromLayout:NO];

        _backgroundView = backgroundView;
        [self addSubview:_backgroundView];
        [self setSubview:_backgroundView excludedFromLayout:YES];

        [self setNeedsLayout];
    }
}

- (void)setSubview:(UIView *)view excludedFromLayout:(BOOL)excluded
{
    if(excluded)
    {
        [_subviewsExcludedFromLayout addObject:view];
    }
    else
    {
        [_subviewsExcludedFromLayout removeObject:view];
    }
}

-(NSArray*)subviewsToAutoLayout
{
    NSMutableArray *subviewsToLayout = [NSMutableArray arrayWithArray:self.subviews];
    NSArray *subviewsExcludedFromLayout = [_subviewsExcludedFromLayout allObjects];
    [subviewsToLayout removeObjectsInArray:subviewsExcludedFromLayout];
    return subviewsToLayout;
}

@end