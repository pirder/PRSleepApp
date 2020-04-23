//
//  PRHomeSleepViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/3/23.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRHomeSleepViewController.h"
#import "PRDataPicker.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PRHomeSleepViewController ()

@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,weak) PRDataPicker *picker;
@property(nonatomic,assign) NSInteger remainingTime;
@property (nonatomic,strong) NSTimer *timer;
@property (strong,nonatomic) AVAudioPlayer *player;

@end

@implementation PRHomeSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor ]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self cleanlyView];
    [self gesture];
    [self setUI];
    // Do any additional setup after loading the view.
}

-(void)cleanlyView{
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    [visualEffectView setFrame:self.view.bounds];
    [self.view addSubview:visualEffectView];
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-30, kScreenHeight/2+150, 60.0, 60.0)];
        //        setFrame:CGRectMake(kScreenWidth/2-30.0, kScreenHeight-49.0-60.0, 60.0, 60.0)];
        [_rightBtn setTitle:@"sleep" forState:UIControlStateNormal];
        //        [_leftBtn setTitle:@"摸我干啥" forState:UIControlStateHighlighted];
        
        [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_rightBtn.layer setBorderWidth:0.5];
        [_rightBtn.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [_rightBtn.layer setCornerRadius:30.0];
        [_rightBtn.layer setMasksToBounds:YES];
        
        [_rightBtn addTarget:self action:@selector(buttonTalk:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _rightBtn;
}
-(void)buttonTalk:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    NSLog(@"%d", sender.selected);

    // 格式
    NSDateFormatter * format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"hh"];
    NSDateFormatter * format2 = [[NSDateFormatter alloc] init];
    [format2 setDateFormat:@"mm"];
    
    // 获取小时
    NSString *str1 = [format1 stringFromDate:_picker.date];
    NSInteger temp1 = [str1 integerValue];
    NSDate *date3 = [[NSDate alloc]init];
    NSString *str3 = [format1 stringFromDate:date3];
    NSInteger temp3 = [str3 integerValue];
    
    // 获取分钟
    NSString *str2 = [format2 stringFromDate:_picker.date];
    NSInteger temp2=[str2 integerValue];
    NSDate *date4 = [[NSDate alloc]init];
    NSString *str4 = [format2 stringFromDate:date4];
    NSInteger temp4 = [str4 integerValue];
    NSLog(@"闹钟时长：%li 秒",(temp1 - temp3) * 60 * 60 + (temp2 - temp4) * 60);
    self.remainingTime = (temp1 - temp3) * 60 * 60 + (temp2 - temp4) * 60;
    
    if (self.remainingTime > 0 && _rightBtn.selected) {
        [self.view reloadInputViews];
        // 当没有定时器的时候, 创建定时器。倘若创建了定时器, 那么放弃定时器。
        if (_timer == nil) {
            //每隔0.01秒刷新一次页面
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        NSLog(@"开始倒计时.....");
    } else {
        NSLog(@"请重新设置时间....");
        self.rightBtn.selected = NO;
        return;
    }
    
}


-(void)setUI{
    [self.view addSubview: self.rightBtn];
    
//    PRDataPicker *picker = [[PRDataPicker alloc] initDatePicker:CGRectMake(kScreenWidth/2+45, 150, 60.0, 60.0)] defaultDate:[NSDate date] selectFutureDate:YES];
//   PRDataPicker *picker = [[PRDataPicker alloc]initDatePicker:CGRectMake(kScreenWidth/2+45, 150, 60.0, 60.0) defaultDate:[NSDate date] selectFutureDate:YES];
//    [self.view addSubview: self.picker];
//    _picker = picker;
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    picker.center = [self.view center];
    picker.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [picker setDatePickerMode:UIDatePickerModeTime];
//    [picker setDatePickerMode:(UIDatePickerMode)]
    [picker.layer setBorderWidth:0.5];
    [picker.layer setCornerRadius:30.0];
    [picker.layer setMasksToBounds:YES];
    [self.view addSubview:picker];
    _picker = picker;
}

- (void)gesture{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnBackground)]];
    
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnBackground)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGesture];
}


- (void)runAction {
    self.remainingTime --;
    if(_remainingTime == 0) {
        [_timer invalidate];//让定时器失效
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击确定关掉闹钟" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self->_player stop];
            self->_rightBtn.selected = NO;
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            self->_timer = nil;
        }];
        
        //提示框弹出的同时，开始响闹钟
        NSString *path = [[NSBundle mainBundle]pathForResource:@"4948.MP3" ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _player.numberOfLoops = -1;    // 无限循环  =0 一遍   =1 两遍    =2 三遍    =负数  单曲循环
        _player.volume = 2;          // 音量
        [_player prepareToPlay];    // 准备工作
        //[_player stop];       // 卡一下
        [_player play];    // 开始播放
        
        // 1 注册通知
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *array = [app scheduledLocalNotifications];
        NSLog(@"%ld", array.count);
        for (UILocalNotification *local in array) {
            NSDictionary *dic = local.userInfo;
            NSLog(@"dicdicdicdicdicdicdicdicdicdicdicdicdicdicdicdicdicdicdic%@", dic);
            if ([dic[@"name"] isEqual:@"zhangsan"]) {
                //删除指定的通知
                [app cancelLocalNotification:local];
            }
        }
        //删除所有通知
        [app cancelAllLocalNotifications];
        //
        
        //判断是否已经注册通知
        UIUserNotificationSettings *setting = [app currentUserNotificationSettings];
        
        // 如果setting.types == UIUserNotificationTypeNone 需要注册通知
        if(setting.types == UIUserNotificationTypeNone){
            UIUserNotificationSettings *newSetting = [UIUserNotificationSettings settingsForTypes:
                                                      UIUserNotificationTypeBadge|
                                                      UIUserNotificationTypeSound|
                                                      UIUserNotificationTypeAlert
                                                                                       categories:nil];
            [app registerUserNotificationSettings:newSetting];
        }else{
            // 如果已经有了通知把它加到本地通知里面
            [self addLocalNotification];
        }
    }
//    NSString *str = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(self.remainingTime) / 3600 % 24, (int)(self.remainingTime) / 60 % 60, (int)(self.remainingTime) % 60];
//    self.labelOfRemainingTime.text = str;
    //    _button.selected = NO;
}

#pragma mark - 增加本地通知
- (void)addLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.alertBody = @"闹钟响了。。。。。。";
    notification.alertAction = @"打开闹钟";
    notification.repeatInterval = NSCalendarUnitSecond;
    notification.applicationIconBadgeNumber = 1;
    //notification.userInfo=@{@"name":@"zhangsan"};
    //notification.soundName=@"4195.mp3";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

//注册完成后调用
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [self addLocalNotification];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"+========我接受到通知了");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_player stop];
}


#pragma mark - Event
- (void)didTapOnBackground{
    //点击空白处，dismiss
    [self customAnimation];
    [self.timer invalidate];
    [self.player stop];
    self.rightBtn.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        if (self->_delegate&&[self->_delegate respondsToSelector:@selector(PRMenuDidTapOnBackground:)]) {
            [self->_delegate PRMenuDidTapOnBackground:self];
        }
    });
}

- (void)customAnimation{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)view;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
                [UIView animateWithDuration:1.f delay:0.02*(btn.tag) usingSpringWithDamping:0.6f initialSpringVelocity:1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    btn.frame = CGRectMake(btn.frame.origin.x, -300, btn.frame.size.width,btn.frame.size.height);
                } completion:^(BOOL finished) {
                }];
            });
        }
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label=(UILabel *)view;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
                [UIView animateWithDuration:1.f delay:0.02*(label.tag) usingSpringWithDamping:0.6f initialSpringVelocity:1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [label setTextColor:[UIColor clearColor]];
                } completion:^(BOOL finished) {
                }];
            });
        }
    }
}

- (void)PRMenuDidTapOnBackground:(PRHomeSleepViewController *)sleepMenu{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self->_player stop];
    self->_timer = nil;
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
