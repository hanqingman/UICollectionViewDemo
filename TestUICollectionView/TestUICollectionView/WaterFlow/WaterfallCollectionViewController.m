//
//  WaterfallCollectionViewController.m
//  TestUICollectionView
//
//  Created by hanqing on 2017/3/13.
//  Copyright © 2017年 imohe. All rights reserved.
//

#import "WaterfallCollectionViewController.h"

#import "WaterfallCollectionViewLayout.h"

#import "WaterfallCell.h"

#import "WaterfallReusableView.h"

@interface WaterfallCollectionViewController ()<WaterfallCollectionViewLayoutDelegate>

@end

@implementation WaterfallCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[WaterfallCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView registerClass:[WaterfallReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.collectionView registerClass:[WaterfallReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.title = @"瀑布流自定义layout";
    
    WaterfallCollectionViewLayout *layout = [[WaterfallCollectionViewLayout alloc] init];
    
    layout.delegate = self;
    
    self.collectionView.collectionViewLayout = layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 17;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor lightGrayColor];

    cell.titleLb.text = [NSString stringWithFormat:@"indexPath\n(%ld,%ld)",indexPath.section,indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath :%ld,%ld,%ld",indexPath.section,indexPath.item,indexPath.row);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WaterfallReusableView *reusableView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor grayColor];
        reusableView.titleLb.text = @"Header";
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor grayColor];
        reusableView.titleLb.text = @"Footer";
    }
    
    return reusableView;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - <WaterfallCollectionViewLayoutDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView columnCountForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout
{
    return 3;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView waterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout heightForItemAtIndex:(NSInteger)index comparedWithWidth:(NSInteger) width
{
    return 80 + index % 3 * 60;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView sectionInsetForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout
{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView lineSpacingForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView interitemSpacingwaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView headerReferenceSizeForWaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout
{
    return CGSizeMake(collectionView.frame.size.width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView footerReferenceSizewaterfallLayout:(WaterfallCollectionViewLayout *)collectionViewLayout
{
    return CGSizeMake(collectionView.frame.size.width, 30);
}


@end
