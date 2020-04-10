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
#import "UserFeedBackViewController.h"
#import <AVOSCloud.h>
#import "PRMyTopicTableViewController.h"
#define curuser  [AVUser currentUser]


@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,PRLoginViewControllerDelegate>
{
        UITableView *personalTableView;
        NSArray *mineOfDataSource;
        NSString *name;
        PRLoginViewController *oginViewControllerForPush ;
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
    mineOfDataSource = @[@"我的心经",@"密码管理",@"意见反馈",@"关于"];
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
        oginViewControllerForPush = [[PRLoginViewController alloc]init];
        [oginViewControllerForPush setModalPresentationStyle:UIModalPresentationFullScreen];
        [oginViewControllerForPush setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [oginViewControllerForPush setDelegate:self];
        [self presentViewController:oginViewControllerForPush animated:YES completion:nil];
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
        return  mineOfDataSource.count;
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
    //取消被选中效果
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userinfo"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 60, 60)];
// 头像处理
          AVQuery *userQuery = [AVUser query];
        [userQuery whereKey:@"username" equalTo:name];
        [userQuery getFirstObjectInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
            if (!error) {
           //     NSLog(@"%@",object);
               // NSLog(@"%@",[[object objectForKey:@"imageHead"] objectForKey:@"url"]);
                NSString *surl = [[object objectForKey:@"imageHead"] objectForKey:@"url"];
                if (surl) {
                    AVFile *file = [AVFile fileWithRemoteURL:[NSURL URLWithString:surl]];
                    [file getThumbnail:YES width:60 height:60 withBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
                        if (!error) {
                            imageView.image = image;
                        }
                        
                    }];
                }
                
            }else{
                imageView.image = [UIImage imageNamed:@"touxiang"];
            }
        }];
       
        [cell.contentView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 150, 80)];
        nameLabel.text = name? name:@"sleepyingBOY";
        [cell.contentView addSubview:nameLabel];
    
        }else if (indexPath.section==1){
            cell.textLabel.text = [mineOfDataSource objectAtIndex:indexPath.row];
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
        
        if(!oginViewControllerForPush){
        oginViewControllerForPush = [[PRLoginViewController alloc]init];
        }
        
        self.definesPresentationContext =NO;
        [oginViewControllerForPush setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [oginViewControllerForPush setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [oginViewControllerForPush setDelegate:self];
        
        [self presentViewController:oginViewControllerForPush animated:YES completion:nil];
        
    }
    
    if (indexPath.section ==1) {
        switch (indexPath.row) {
            case 0://我的心经
                [self presentViewController:[[PRMyTopicTableViewController alloc]init] animated:YES completion:^{
                    
                }];
                break;
            case 1://密码管理
                [self resetPasswordBtn];
                break;
            case 2://意见反馈
                [self pushFeedBack];
                break;
            default:
                //关于
                [self alterShowLitterTitle:@"关于本APP" message:@"基于毕业设计的题目开发"];
                break;
        }
    }
//    NSLog(@"%d",indexPath.row);
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

-(void)pushFeedBack{
    
//    [self oller:[[UserFeedBackViewController alloc]init] animated:YES];
    [self presentViewController:[[UserFeedBackViewController alloc]init] animated:YES completion:^{
        
    }];
}

-(void)resetPasswordBtn{
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"请输入正确的邮箱名" message:@"重置密码收到邮件及时查看修改" preferredStyle:UIAlertControllerStyleAlert];
    [alert1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入邮箱名";
    }];
    [alert1 addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    [alert1 addAction:[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *email = alert1.textFields.firstObject.text;
        [AVUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [self alterShowLitterTitle:@"发送成功" message:@"请及时查看邮件"];
            }else{
                [self alterShowLitterTitle:@"发送失败" message:@"请再次确认邮箱"];
            }
        }];
        
    }]];
    [self presentViewController:alert1 animated:YES completion:nil];
}



-(void)alterShowLitterTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    //控制提示框显示的时间为2秒
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:2.0];
}

- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}
@end
