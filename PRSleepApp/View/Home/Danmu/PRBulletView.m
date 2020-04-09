//
//  PRBulletView.m
//  PRSleepApp
//
//  Created by priders on 2020/4/9.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRBulletView.h"
#define Padding 10
#define PhotoHeight 30

@interface PRBulletView ()
@property (nonatomic,strong) UILabel *bulletLabel;
@property (nonatomic,strong) UIImageView *photoImgView;
@end

@implementation PRBulletView
/** 初始化弹幕*/
-(instancetype)initWithComment:(NSString *)string
{
    if (self = [super init]) {
        //        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor darkGrayColor];
        UIFont *labelFont = [UIFont systemFontOfSize:14];
        NSDictionary *attr = @{NSFontAttributeName:labelFont};
        CGFloat stringWidth = [string sizeWithAttributes:attr].width;
        
        _bulletLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = labelFont;
            label.textColor = [UIColor whiteColor];
            label;
        });
        [self addSubview:_bulletLabel];
        
        CGFloat heifht = 30;
        self.layer.cornerRadius = heifht / 2;
        self.bounds = CGRectMake(0, 0, stringWidth + 2 * Padding + PhotoHeight, heifht);
        _bulletLabel.text = string;
        _bulletLabel.frame = CGRectMake(Padding + PhotoHeight, 0, stringWidth, heifht);
        
        _photoImgView = ({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(-Padding, -Padding, PhotoHeight + Padding, PhotoHeight + Padding)];
            iv.clipsToBounds = YES;
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.backgroundColor = [UIColor whiteColor];
            iv.layer.cornerRadius = (PhotoHeight + Padding) / 2;
            iv.layer.borderColor = [UIColor darkGrayColor].CGColor;
            iv.layer.borderWidth = 1;
            iv.image = [UIImage imageNamed: @"email"];
            iv;
        });
        [self addSubview:_photoImgView];
    }
    
    return self;
}
/** 开始动画*/
-(void)startAnimation
{
    // 弹幕开始
    self.moveStatusBlock(PRBulletMoveStatusStart);
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat bulletWidth = CGRectGetWidth(self.bounds);
    // 弹幕越长 动画时间越长, 速度越慢.
    CGFloat duration = (bulletWidth / (screenW / 4))  * 6.0;
    CGFloat wholeWidth = screenW + bulletWidth;
    
    CGFloat speed = wholeWidth / duration;
    CGFloat enterDelay = bulletWidth / speed;
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDelay];
    
    __block CGRect frame = self.frame;
    frame.origin.x = screenW;
    self.frame = frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = -bulletWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.moveStatusBlock) {
            self.moveStatusBlock(PRBulletMoveStatusEnd);
        }
    }];
}
/** 结束动画*/
-(void)stopAnimation
{
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(enterScreen) object:nil];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

-(void)enterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(PRBulletMoveStatusEnter);
    }
}


@end
