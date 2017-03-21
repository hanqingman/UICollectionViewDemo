//
//  WaterfallCollectionViewLayout.m
//  TestUICollectionView
//
//  Created by hanqing on 2017/3/13.
//  Copyright © 2017年 imohe. All rights reserved.
//

#import "WaterfallCollectionViewLayout.h"

@interface WaterfallCollectionViewLayout ()

//行间距
@property (nonatomic) CGFloat lineSpacing;

//列间距
@property (nonatomic) CGFloat interitemSpacing;

//header size
@property (nonatomic) CGSize headerReferenceSize;

//footer size
@property (nonatomic) CGSize footerReferenceSize;

//section inset
@property (nonatomic) UIEdgeInsets sectionInset;

//列数
@property (nonatomic) NSInteger columnCount;

//UICollectionViewLayoutAttributes二级列表
@property (nonatomic, strong) NSMutableArray *attributesArray;

//记录每列的高度
@property (nonatomic, strong) NSMutableArray *columnHeights;

//滚动视图高度
@property (assign,nonatomic) CGFloat contentHeight;

@end

@implementation WaterfallCollectionViewLayout

// The collection view calls -prepareLayout once at its first layout as the first message to the layout instance.
// The collection view calls -prepareLayout again after layout is invalidated and before requerying the layout information.
// Subclasses should always call super if they override.
- (void)prepareLayout
{
    [super prepareLayout];
    //初始化
    [self.attributesArray removeAllObjects];
    
    [self.columnHeights removeAllObjects];
    
    self.contentHeight = 0;
    
    
    //初始化每列高度（sectionInset.top）
    for (int i = 0; i < self.columnCount; i++)
    {
        [self.columnHeights addObject:@(self.headerReferenceSize.height)];
    }
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    
    CGFloat itemWidth = (collectionViewWidth - self.sectionInset.left - self.sectionInset.right - self.interitemSpacing * (self.columnCount - 1)) / self.columnCount;
    
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < items; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat itemHeight = itemWidth;
        
        if ([self.delegate respondsToSelector:@selector(collectionView:waterfallLayout:heightForItemAtIndex:comparedWithWidth:)])
        {
            itemHeight = [self.delegate collectionView:self.collectionView waterfallLayout:self heightForItemAtIndex:indexPath.row comparedWithWidth:itemWidth];
        }
        
        //确认当前item属于第几列
        int column = 0;
        
        CGFloat minColumnHeight = [(NSNumber *)self.columnHeights[0] floatValue];
        
        for (int c = 1; c < self.columnCount; c++)
        {
            //找出每行最小高度列
            if (minColumnHeight > [(NSNumber *)self.columnHeights[c] floatValue])
            {
                minColumnHeight = [(NSNumber *)self.columnHeights[c] floatValue];
                
                column = c;
            }
        }
        
        CGFloat x = self.sectionInset.left + (itemWidth + self.interitemSpacing) * column;

        CGFloat y = [(NSNumber *)self.columnHeights[column] floatValue] + (i / self.columnCount == 0 ? self.sectionInset.top : self.lineSpacing);
        
        self.columnHeights[column] = @(y + itemHeight);
        
        //属性设置
        attributes.frame = CGRectMake(x, y, itemWidth, itemHeight);
        
        [self.attributesArray addObject:attributes];
    }
    
    self.contentHeight += self.sectionInset.bottom + self.footerReferenceSize.height;
    
    //找到最大高度
    CGFloat maxColumnHeight = [(NSNumber *)self.columnHeights[0] floatValue];
    
    for (int c = 1; c < self.columnCount; c++)
    {
        //找出每行最小高度列
        if (maxColumnHeight < [(NSNumber *)self.columnHeights[c] floatValue])
        {
            maxColumnHeight = [(NSNumber *)self.columnHeights[c] floatValue];
        }
    }
    
    self.contentHeight += maxColumnHeight;
    
    //header & footer
    [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];

}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// UICollectionView calls these four methods to determine the layout information.
// Implement -layoutAttributesForElementsInRect: to return layout attributes for for supplementary or decoration views, or to perform layout in an as-needed-on-screen fashion.
// Additionally, all layout subclasses should implement -layoutAttributesForItemAtIndexPath: to return layout attributes instances on demand for specific index paths.
// If the layout supports any supplementary or decoration view types, it should also implement the respective atIndexPath: methods for those types.
// return an array layout attributes instances for all the views in the given rect
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

//系统不会主动调用该方法
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = self.attributesArray[indexPath.item];
    
    return attributes;
}

//系统不会主动调用该方法
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader])
    {
        attributes.frame = CGRectMake(0, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
    }
    else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        attributes.frame = CGRectMake(0, self.contentHeight -  self.footerReferenceSize.height, self.footerReferenceSize.width, self.footerReferenceSize.height);
    }
    
    return attributes;
}
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

#pragma mark - lazy load

- (NSMutableArray *)attributesArray
{
    if (!_attributesArray)
    {
        _attributesArray = [NSMutableArray new];
    }
    return _attributesArray;
}

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights)
    {
        _columnHeights = [NSMutableArray new];
    }
    return _columnHeights;
}

- (CGFloat)lineSpacing
{
    _lineSpacing = 0;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:lineSpacingForWaterfallLayout:)])
    {
        _lineSpacing = [self.delegate collectionView:self.collectionView lineSpacingForWaterfallLayout:self];
    }
    return _lineSpacing;
}

- (CGFloat)interitemSpacing
{
    _interitemSpacing = 0;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:interitemSpacingwaterfallLayout:)])
    {
        _interitemSpacing = [self.delegate collectionView:self.collectionView interitemSpacingwaterfallLayout:self];
    }
    return _interitemSpacing;
}

- (UIEdgeInsets)sectionInset
{
    _sectionInset = UIEdgeInsetsZero;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:sectionInsetForWaterfallLayout:)])
    {
        _sectionInset = [self.delegate collectionView:self.collectionView sectionInsetForWaterfallLayout:self];
    }
    return _sectionInset;
}

- (NSInteger)columnCount
{
    _columnCount = 1;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:columnCountForWaterfallLayout:)])
    {
        _columnCount = [self.delegate collectionView:self.collectionView columnCountForWaterfallLayout:self];
    }
    return _columnCount;
}

- (CGSize)headerReferenceSize
{
    _headerReferenceSize = CGSizeZero;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:headerReferenceSizeForWaterfallLayout:)])
    {
        _headerReferenceSize = [self.delegate collectionView:self.collectionView headerReferenceSizeForWaterfallLayout:self];
    }
    return _headerReferenceSize;
}

- (CGSize)footerReferenceSize
{
    _footerReferenceSize = CGSizeZero;
    
    if ([self.delegate respondsToSelector:@selector(collectionView:footerReferenceSizewaterfallLayout:)])
    {
        _footerReferenceSize = [self.delegate collectionView:self.collectionView footerReferenceSizewaterfallLayout:self];
    }
    return _footerReferenceSize;
}

@end

