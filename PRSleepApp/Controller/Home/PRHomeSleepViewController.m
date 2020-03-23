//
//  PRHomeSleepViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/3/23.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRHomeSleepViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface PRHomeSleepViewController ()
@property (nonatomic,strong) UIButton *rightBtn;
@end

@implementation PRHomeSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2+45, kScreenHeight-120.0-60.0, 60.0, 60.0)];
        //        setFrame:CGRectMake(kScreenWidth/2-30.0, kScreenHeight-49.0-60.0, 60.0, 60.0)];
        [_rightBtn setTitle:@"畅聊" forState:UIControlStateNormal];
        //        [_leftBtn setTitle:@"摸我干啥" forState:UIControlStateHighlighted];
        
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn.layer setBorderWidth:0.5];
        [_rightBtn.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [_rightBtn.layer setCornerRadius:30.0];
        [_rightBtn.layer setMasksToBounds:YES];
        
        [_rightBtn addTarget:self action:@selector(buttonTalk) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _rightBtn;
}
-(void)setUI{
    [self.view addSubview: self.rightBtn];
}

- (void)gesture{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnBackground)]];
    
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnBackground)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGesture];
}

#pragma mark - Event
- (void)didTapOnBackground{
    //点击空白处，dismiss
    [self customAnimation];
    
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
