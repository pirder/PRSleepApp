//
//  MineViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/2/18.
//  Copyright © 2020 priders. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
 {
        UITableView *personalTableView;
        NSArray *dataSource;
    }

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    personalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:personalTableView];
    personalTableView.dataSource = self;
    personalTableView.delegate = self;
    personalTableView.bounces = NO;//yes，就是滚动超过边界会反弹有反弹回来的效果; NO，那么滚动到达边界会立刻停止。
    personalTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    personalTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    dataSource = @[@"我的分享",@"密码管理",@"用户协议",@"关于"];
    
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backView];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 3;
}



@end
