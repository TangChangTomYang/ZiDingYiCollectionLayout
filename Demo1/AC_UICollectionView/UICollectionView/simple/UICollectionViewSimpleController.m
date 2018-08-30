//
//  UIcollectionViewSimpleController.m
//  AC_UICollectionView
//
//  Created by FM-13 on 16/6/22.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "UICollectionViewSimpleController.h"
#import "SimpleCollectionViewCell.h"
#import "SimpleHeadCollectionReusableView.h"
#import "SimpleFootCollectionReusableView.h"

@interface UICollectionViewSimpleController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation UICollectionViewSimpleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.itemSize = CGSizeMake(80, 80);
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.headerReferenceSize = CGSizeMake(60, 40);
    self.flowLayout.footerReferenceSize = CGSizeMake(60, 40);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"simpleCell"];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleHeadCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simpleHead"];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleFootCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"simpleFoot"];
    
    self.dataArr = [NSMutableArray array];
    
    for (int i = 0; i < 50; i++) {
        CGSize size = CGSizeMake((arc4random() % 20) + 20, (arc4random() % 20) + 30);
        NSValue *value = [NSValue valueWithCGSize:size];
        
        [self.dataArr addObject:value];
        
    }
    
    
    
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGest:)];
    [self.collectionView addGestureRecognizer:longGest];
}

//处理移动相关
- (void)longGest:(UILongPressGestureRecognizer *)gest
{
    switch (gest.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *touchIndexPath = [self.collectionView indexPathForItemAtPoint:[gest locationInView:self.collectionView]];
            if (touchIndexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:touchIndexPath];
            }else{
                break;
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[gest locationInView:gest.view]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0)
{
    NSValue *value = self.dataArr[sourceIndexPath.item];
    [self.dataArr removeObjectAtIndex:sourceIndexPath.item];
    [self.dataArr insertObject:value atIndex:destinationIndexPath.item];
        NSLog(@"from:%ld      to:%ld", sourceIndexPath.row, destinationIndexPath.row);
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSValue *value = self.dataArr[indexPath.row];
//    
//    CGSize size = [value CGSizeValue];
//    
//    return size;
//}

//设置head foot视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SimpleHeadCollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"simpleHead" forIndexPath:indexPath];
        return head;
    }else{
        SimpleFootCollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"simpleFoot" forIndexPath:indexPath];
        return foot;
    }
}

//设置是否可以选中cell
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



//设置是否支持高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//设置高亮颜色
- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blueColor];
}
//取消高亮颜色
- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
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
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:itemPaths];
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){

    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        NSArray* itemPaths = @[indexPath];
        [self.dataArr insertObject:self.dataArr[indexPath.row] atIndex:indexPath.row];
        [self.collectionView insertItemsAtIndexPaths:itemPaths];
    }
    
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    
    cell.textTitle.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
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

@end
