//
//  PRLoginViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/3/27.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRLoginViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MineViewController.h"
#import "PRSignupViewController.h"
//屏幕宽高
#define ScreenWidth  self.view.frame.size.width
#define ScreenHeight self.view.frame.size.height

//头像的宽高
#define  QQHeadX      (ScreenWidth-0.25*ScreenWidth)/2
#define  QQHeadY        80
#define QQHeadWidth     0.25*ScreenWidth
#define QQHeadHeight    0.25*ScreenWidth

//账号的宽高
#define AccountX    0
#define AccountY    QQHeadY+QQHeadHeight+20
#define AccountW    ScreenWidth
#define AccountH    50

//密码的宽高
#define PasswordX   0
#define PasswordY   AccountY+50
#define PasswordW   ScreenWidth
#define PasswordH   50

//登陆的宽高
#define LoginX   35
#define LoginY   PasswordY+PasswordH+20
#define LoginW   ScreenWidth-2*LoginX
#define LoginH   50

//无法登陆？
#define FailedX   5
#define FailedY   0.95*ScreenHeight
#define FailedW   80
#define FailedH   25
//新用户
#define NewX   0.8*ScreenWidth
#define NewY   0.95*ScreenHeight
#define NewW   80
#define NewH   25
@interface PRLoginViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,PRSignupViewControllerDelegate>
//图片选择器协议

@property (nonatomic,strong)UIButton *UserImageBtn ,   *LoginBtn,  *FailedBtn ,  *NewBtn,*LogupBtn ;
@property(nonatomic,strong )UITextField  *accountTextField , *passwordTextField;

@end





@implementation PRLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //=======================================================
    
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    //分配初始化用户头像按钮。
    self.UserImageBtn =[[UIButton alloc] initWithFrame:CGRectMake( (ScreenWidth-0.25*self.view.frame.size.width) / 2,80,
                                                                  0.25*self.view.frame.size.width ,0.25*self.view.frame.size.width )];
    
    //设置头像控件的图片
 //   [self.UserImageBtn setBackgroundImage:[UIImage imageNamed:@"login_header@2x.png"] forState:(UIControlStateNormal)];
    [self.UserImageBtn setBackgroundImage:[UIImage imageNamed:@"touxiang.png"] forState:(UIControlStateNormal)];
    
    //圆形头像
    _UserImageBtn.layer.cornerRadius =QQHeadHeight/2;
    _UserImageBtn.layer.masksToBounds=YES;
    
    //添加头像控件的改变头像事件
    [_UserImageBtn addTarget:self action:@selector(setUserImageBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //将头像控件添加到视图上
    [self.view addSubview:self.UserImageBtn];
    
    //=======================================================
    
    //分配初始化账号和密码控件
    self.accountTextField=[[UITextField alloc] initWithFrame:CGRectMake(AccountX, AccountY, AccountW, AccountH)];
    self.passwordTextField=[[UITextField alloc] initWithFrame:CGRectMake(PasswordX, PasswordY, PasswordW, PasswordH)];
    
    //设置账号和密码框控件的位置，提示字符，键盘类型
    _accountTextField.textAlignment=NSTextAlignmentCenter;
    _accountTextField.placeholder=@"用户名" ;
    _accountTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    _passwordTextField.textAlignment=NSTextAlignmentCenter;
    _passwordTextField.placeholder=@"密码" ;
    _passwordTextField.keyboardType=UIKeyboardTypeAlphabet;
    
    //设置密码密文显示
    _passwordTextField.secureTextEntry=YES;
    
    //将账号和密码控件添加到视图
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    
    //=======================================================
    
    
    //分配初始化登陆控件
    self.LoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(LoginX, LoginY, LoginW, LoginH)];
    
    //设置登陆控件的效果图片
    [self.LoginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_nor@2x.png"] forState:(UIControlStateNormal)];//正常
    [self.LoginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_blue_press@2x.png"] forState:(UIControlStateHighlighted)];//高亮
    
    //添加登陆控件的登陆事件
    [self.LoginBtn addTarget:self action:@selector(LoginBtnClickListener) forControlEvents:UIControlEventTouchUpInside];
    
    //将登陆控件添加到视图
    [self.view addSubview:self.LoginBtn];
    
        //=======================================================
    
    //分配初始化注册控件
    self.LogupBtn=[[UIButton alloc] initWithFrame:CGRectMake(LoginX, LoginY+LoginH+15, LoginW, LoginH)];
    
    //设置注册控件的效果图片
    [self.LogupBtn setBackgroundImage:[UIImage imageNamed:@"logup_btn_blue_nor@2x.png"] forState:(UIControlStateNormal)];//正常
    [self.LogupBtn setBackgroundImage:[UIImage imageNamed:@"logup_btn_blue_nor@2x.png"] forState:(UIControlStateHighlighted)];//高亮
    
    //添加注册控件的登陆事件
    [self.LogupBtn addTarget:self action:@selector(LogupBtnClickListener) forControlEvents:UIControlEventTouchUpInside];
    
    //将注册控件添加到视图
    [self.view addSubview:self.LogupBtn];
    
    //=======================================================
    
    //分配初始化-无法登陆控件
    self.FailedBtn=[[UIButton alloc] initWithFrame:CGRectMake(FailedX , FailedY, FailedW, FailedH)];
    
    //设置无法登陆控件的背景图片
    [self.FailedBtn setBackgroundImage: [UIImage imageNamed:@"failed.png"] forState:(UIControlStateNormal)];
    
    //将无法登陆控件添加到视图
    [self.view addSubview:self.FailedBtn];
    
    //=======================================================
    
    //分配初始化新用户控件
    self.NewBtn=[[UIButton alloc] initWithFrame:CGRectMake(NewX, NewY, NewW, NewH)];
    
    //设置新用户控件的背景图片
    [self.NewBtn setBackgroundImage:[UIImage imageNamed:@"new.png"] forState:(UIControlStateNormal)];//正常
    
    //将新用户控件添加到视图
    [self.view addSubview:self.NewBtn];
}
//=======================================================
//=======================================================
//=======================================================
//=======================================================


//实现改变QQ头像事件
-(void)setUserImageBtnAction:(UIButton *)UserImageBtn{
    
    //分配初始化图片选择器控件
    UIImagePickerController *imagePicker =  [[UIImagePickerController alloc]init];
    
    //设置图片来源为系统相册
    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    //使用图片代理-查看协议-并实现“didFinishPickingImage”事件
    imagePicker.delegate=self;
    
    //使用模态窗口显示相册
    [self  presentViewController:imagePicker animated:YES completion:nil];
}

//=======================================================

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    //设置新头像
    [_UserImageBtn setBackgroundImage:image forState:(UIControlStateNormal)];
    
    //模态方式退出图像选择器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//=======================================================

//实现登陆控件的登陆事件
- (void)LoginBtnClickListener{
    NSString *username = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    //密码为空
    if ([username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length ==0
        || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length ==0 ) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"错误" message:@"用户密码不能为空" preferredStyle:(UIAlertControllerStyleAlert) ];
        
        //添加按钮到提示窗
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style: (UIAlertActionStyleDefault) handler:nil]];
        //显示提示框
        [self presentViewController:alertController   animated:YES completion:nil];
    }
    if (username && password) {
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
            if (user) {
                NSLog(@"登录成功");
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //登陆成功后把用户名和密码存储到UserDefault
                [userDefaults setObject:username forKey:@"username"];
                [userDefaults setObject:password forKey:@"password"];
                [userDefaults synchronize];
//                [self dismissViewControllerAnimated:YES completion:nil];
                [self dismissViewControllerAnimated:YES completion:^{
//                   
                }];
                [self.delegate testLoadData];
                
            }else{
                NSLog(@"登录失败");
            }
            
        }];
    }
    

    
}

-(void)LogupBtnClickListener{
    PRSignupViewController *signup = [[PRSignupViewController alloc]init];
    [signup setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [signup setModalPresentationStyle:UIModalPresentationFullScreen];
    [signup setDelegate:self];
    [self presentViewController:signup animated:YES completion:nil];
    
}


//点击空白地方返回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.delegate removeNowController];
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"username"]) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        for (UIViewController *vc in [UIApplication sharedApplication].keyWindow.rootViewController) {
//            if([vc isKindOfClass: [UINavigationController class]){
//                vc
//            }
//        }
//                
//                
//                
//        [[[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
//    }
}
- (void)successSignUpAutoLogin:(AVUser *)Signuser{
    [AVUser logInWithUsernameInBackground:Signuser.username password:Signuser.password block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            NSLog(@"登录成功");
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //登陆成功后把用户名和密码存储到UserDefault
            [userDefaults setObject:Signuser.username forKey:@"username"];
            [userDefaults setObject:Signuser.password forKey:@"password"];
            
            [userDefaults synchronize];
            //                [self dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            [self.delegate testLoadData];
            
        }else{
            NSLog(@"登录失败");
        }
    }];
}

@end

