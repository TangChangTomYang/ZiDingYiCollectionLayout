//
//  WaterViewController.m
//  AC_UICollectionView
//
//  Created by FM-13 on 16/6/23.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "WaterViewController.h"
#import "AC_WaterCollectionViewLayout.h"
#import "AC_WaterCollectionViewCell.h"
#import "SimpleHeadCollectionReusableView.h"
#import "SimpleFootCollectionReusableView.h"

@interface WaterViewController () <UICollectionViewDelegate, UICollectionViewDataSource,AC_WaterCollectionViewLayoutDelegate>

@property (strong, nonatomic) UICollectionView *waterCollectionView;
@property (strong, nonatomic) AC_WaterCollectionViewLayout *waterLayout;
@property (strong, nonatomic) NSMutableArray *imageArr;

@end

@implementation WaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waterLayout = [[AC_WaterCollectionViewLayout alloc] init];
    self.waterLayout.footViewHeight = 60;
    self.waterLayout.headerViewHeight = 100;
    self.waterLayout.delegate = self;
    
    
    self.waterCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.waterLayout];
    self.waterCollectionView.backgroundColor = [UIColor whiteColor];
    self.waterCollectionView.delegate = self;
    self.waterCollectionView.dataSource = self;
    [self.view addSubview:self.waterCollectionView];
    
    
    [self.waterCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AC_WaterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"waterCell"];
    [self.waterCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleHeadCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:AC_UICollectionElementKindSectionHeader withReuseIdentifier:@"simpleHead"];
    
    [self.waterCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleFootCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:AC_UICollectionElementKindSectionFooter withReuseIdentifier:@"simpleFoot"];

    
    
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGest:)];
    [self.waterCollectionView addGestureRecognizer:longGest];

    
}

- (void)longGest:(UILongPressGestureRecognizer *)gest
{
    switch (gest.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *touchIndexPath = [self.waterCollectionView indexPathForItemAtPoint:[gest locationInView:self.waterCollectionView]];
            if (touchIndexPath) {
                [self.waterCollectionView beginInteractiveMovementForItemAtIndexPath:touchIndexPath];
            }else{
                break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.waterCollectionView updateInteractiveMovementTargetPosition:[gest locationInView:gest.view]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.waterCollectionView endInteractiveMovement];
        }
            break;
        default:
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0)
{
    
//    if(sourceIndexPath.row != destinationIndexPath.row){
//        NSString *value = [self.imageArr[sourceIndexPath.row] mutableCopy];
//        [self.imageArr removeObjectAtIndex:sourceIndexPath.row];
//        [self.imageArr insertObject:value atIndex:destinationIndexPath.row];
//        NSLog(@"from:%ld      to:%ld", sourceIndexPath.row, destinationIndexPath.row);
//    }
   
}

- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
        for(int i = 1; i <= 100; i++) {
            [_imageArr addObject:[NSString stringWithFormat:@"%d.jpg", i%20]];
        }
    }
    return _imageArr;
    
}


//设置head foot视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:AC_UICollectionElementKindSectionHeader]) {
        SimpleHeadCollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"simpleHead" forIndexPath:indexPath];
        return head;
    }else if([kind isEqualToString:AC_UICollectionElementKindSectionFooter]){
        SimpleFootCollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"simpleFoot" forIndexPath:indexPath];
        return foot;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    cell.contentView.alpha = 0;
    cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0);

    
    [UIView animateKeyframesWithDuration:.5 delay:0.0 options:0 animations:^{
        
        /**
         *  分步动画   第一个参数是该动画开始的百分比时间  第二个参数是该动画持续的百分比时间
         */
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            cell.contentView.alpha = .5;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.2, 1.2), 0);

        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            cell.contentView.alpha = 1;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0);

        }];

    } completion:^(BOOL finished) {
        
    }];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AC_WaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.textTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    
    return cell;
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath {
    return [UIImage imageNamed:[self.imageArr objectAtIndex:indexPath.row]];
}


#pragma mark- AC_WaterCollectionViewLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(AC_WaterCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return [self imageAtIndexPath:indexPath].size.height/[self imageAtIndexPath:indexPath].size.width * itemWidth;
}

- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    if(sourceIndexPath.row != destinationIndexPath.row){
        NSString *value = self.imageArr[sourceIndexPath.row];
        [self.imageArr removeObjectAtIndex:sourceIndexPath.row];
        [self.imageArr insertObject:value atIndex:destinationIndexPath.row];
        NSLog(@"from:%ld      to:%ld", sourceIndexPath.row, destinationIndexPath.row);
    }
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    //长按支持的事件  cut: paste: copy:
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"]) {
        return YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        return YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
    NSLog(@"点击了%@事件", NSStringFromSelector(action));
    
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"]) {
        NSArray* itemPaths = @[indexPath];
        [self.imageArr removeObjectAtIndex:indexPath.row];
        [self.waterCollectionView deleteItemsAtIndexPaths:itemPaths];
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        
    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        NSArray* itemPaths = @[indexPath];
        [self.imageArr insertObject:self.imageArr[indexPath.row] atIndex:indexPath.row];
        [self.waterCollectionView insertItemsAtIndexPaths:itemPaths];
    }
    
    
}




@end
