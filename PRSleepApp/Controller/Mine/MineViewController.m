//
//  MineViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/2/18.
//  Copyright © 2020 priders. All rights reserved.
//

#import "MineViewController.h"
#import "PRLoginViewController.h"
#import "HomeViewController.h"
#import <AVOSCloud.h>

#define curuser  [AVUser currentUser]


@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,PRLoginViewControllerDelegate>
{
        UITableView *personalTableView;
        NSArray *dataSource;
        NSString *name;
        PRLoginViewController *login ;
        BOOL isLogin;
    
}


@end



@implementation MineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self startUI];
//    [self setUI];

    // Do any additional setup after loading the view.
}

-(void)setLoginedUI{
    personalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:personalTableView];
    personalTableView.dataSource = self;
    personalTableView.delegate = self;
    personalTableView.bounces = NO;//yes，就是滚动超过边界会反弹有反弹回来的效果; NO，那么滚动到达边界会立刻停止。
    personalTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    personalTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    dataSource = @[@"我的心经",@"密码管理",@"意见反馈",@"关于"];
}
- (void)setUI{
    //判断是否登陆，由登陆状态判断启动页面
    //获取UserDefault
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    name = [userDefault objectForKey:@"username"];
    
    //如果用户未登陆则把视图控制器改变成登陆视图控制器
//        personalTableView.hidden = YES;
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//        backView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:backView];

        
        //背景
//        self.definesPresentationContext =NO;
       
//        personalTableView.hidden = NO;
   
}
-(void)startUI{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    name = [userDefault objectForKey:@"username"];
    if (name) {
        //已经登录
        isLogin = YES;
        NSLog(@"登录成功页面");
        [self setLoginedUI];
    }
    else{
        //未登录
        isLogin = NO;
        login = [[PRLoginViewController alloc]init];
        [login setModalPresentationStyle:UIModalPresentationFullScreen];
        [login setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [login setDelegate:self];
        [self presentViewController:login animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
   //d如果没有登录
   // 提示登录效果
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    backView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backView];
//
    NSLog(@"%@",name);
    if (!name) {
        NSLog(@"登录未成功页面");
        [self startUI];
    }
    
    

   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 3;
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  1;
    }
    else if(section == 1){
        return  dataSource.count;
    }
    else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //上头高度
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //下面高度
    //
    if (section == 2) {
        return 40;
    }
    return 20;
    
}


//每组的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userinfo"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 60, 60)];
// 投降处理
          AVQuery *userQuery = [AVUser query];
        [userQuery whereKey:@"username" equalTo:name];
        [userQuery getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
           //     NSLog(@"%@",object);
               // NSLog(@"%@",[[object objectForKey:@"imageHead"] objectForKey:@"url"]);
                NSString *surl = [[object objectForKey:@"imageHead"] objectForKey:@"url"];
                AVFile *file = [AVFile fileWithRemoteURL:[NSURL URLWithString:surl]];
               [file getThumbnail:YES width:60 height:60 withBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    imageView.image = image;
               }];
            }else{
                imageView.image = [UIImage imageNamed:@"touxiang"];
            }
        }];
       
        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 80)];
        nameLabel.text = name? name:@"sleepyingBOY";
        [cell.contentView addSubview:nameLabel];
    
        }else if (indexPath.section==1){
            cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
            //设置Cell右边的小箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        }else{
                 cell.textLabel.text = @"退出登录";
                 cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        //退出登录
        [AVUser logOut];
        NSLog(@"exit");
        //获取UserDefaults单例
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //移除UserDefaults中存储的用户信息
        [userDefaults removeObjectForKey:@"username"];
        [userDefaults removeObjectForKey:@"password"];
        [userDefaults synchronize];
        name=nil;
        
        if(!login){
        login = [[PRLoginViewController alloc]init];
        }
        
        self.definesPresentationContext =NO;
        [login setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [login setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [login setDelegate:self];
        [self presentViewController:login animated:YES completion:nil];
//       [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [self loadView];
//        tableView.reloadData;
    }
}

- (void)testLoadData{
    NSLog(@"返回值");
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    name = [userDefault objectForKey:@"username"];
    if (name) {
         [self startUI];
    }
   
//    [personalTableView reloadData];
//    [self setUI];
}
-(void)removeNowController{
//    [self.navigationController popToViewController:[[HomeViewController alloc ]init]animated:YES];
    UITabBarController *tabbarCtrl = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
//    UINavigationController *navCtrl = tabbarCtrl.selectedViewController;
    [tabbarCtrl setSelectedIndex:0];
    
}

@end
