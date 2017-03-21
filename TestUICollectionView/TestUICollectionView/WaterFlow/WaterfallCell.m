//
//  WaterfallCell.m
//  TestUICollectionView
//
//  Created by hanqing on 2017/3/20.
//  Copyright © 2017年 imohe. All rights reserved.
//

#import "WaterfallCell.h"

@implementation WaterfallCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.titleLb];
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
    
    _titleLb.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

@end
