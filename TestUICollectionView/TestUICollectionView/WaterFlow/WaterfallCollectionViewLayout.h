//
//  CustomCollectionViewLayout.h
//  TestUICollectionView
//
//  Created by hanqing on 2017/3/13.
//  Copyright © 2017年 imohe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallCollectionViewLayout;

@protocol WaterfallCollectionViewLayoutDelegate <NSObject>

//通过比对width，获取height
- (CGFloat)collectionView:(UICollectionView *)collectionView waterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout heightForItemAtIndex:(NSInteger)index comparedWithWidth:(NSInteger) width;

//列数
- (CGFloat)collectionView:(UICollectionView *)collectionView columnCountForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout;

@optional

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView sectionInsetForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout;
- (CGFloat)collectionView:(UICollectionView *)collectionView lineSpacingForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout ;
- (CGFloat)collectionView:(UICollectionView *)collectionView interitemSpacingwaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView headerReferenceSizeForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout;
- (CGSize)collectionView:(UICollectionView *)collectionView footerReferenceSizewaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout;

@end

@interface WaterfallCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterfallCollectionViewLayoutDelegate> delegate;

@end

