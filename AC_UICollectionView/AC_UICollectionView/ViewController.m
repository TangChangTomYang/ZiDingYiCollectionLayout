//
//  ViewController.m
//  AC_UICollectionView
//
//  Created by FM-13 on 16/6/22.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "ViewController.h"
#import "UICollectionViewSimpleController.h"
#import "WaterViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArr = @[@"UICollectionView基础使用", @"瀑布流"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            UICollectionViewSimpleController *ctr = [[UICollectionViewSimpleController alloc] init];
            ctr.view.backgroundColor = [UIColor whiteColor];
            ctr.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:ctr animated:YES];
        }
            
            break;
        case 1:{
            WaterViewController *ctr = [[WaterViewController alloc] init];
            ctr.view.backgroundColor = [UIColor whiteColor];
            ctr.title = self.titleArr[indexPath.row];
            [self.navigationController pushViewController:ctr animated:YES];
        }
            
            break;
    }
}

@end
