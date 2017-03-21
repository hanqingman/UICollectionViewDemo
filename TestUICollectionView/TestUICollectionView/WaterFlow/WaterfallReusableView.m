//
//  WaterfallReusableView.m
//  TestUICollectionView
//
//  Created by hanqing on 2017/3/21.
//  Copyright © 2017年 imohe. All rights reserved.
//

#import "WaterfallReusableView.h"

@implementation WaterfallReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubview:self.titleLb];
    }
    return self;
}

#pragma mark - lazy load

- (UILabel *)titleLb
{
    if (!_titleLb)
    {
        _titleLb = [[UILabel alloc] init];
        
        _titleLb.backgroundColor = [UIColor clearColor];
        
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLb.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
