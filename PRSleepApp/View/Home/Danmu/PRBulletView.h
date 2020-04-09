//
//  PRBulletView.h
//  PRSleepApp
//
//  Created by priders on 2020/4/9.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PRBulletMoveStatus) {
    PRBulletMoveStatusStart,
    PRBulletMoveStatusEnter,
    PRBulletMoveStatusEnd,
};
@interface PRBulletView : UIView

@property (nonatomic, assign) int trajectory; //弹道
@property (nonatomic,copy) void(^moveStatusBlock)(PRBulletMoveStatus status);//弹幕状态回调；

//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment;

//开始动画
-(void)startAnimation;

//结束动画
-(void)stopAnimation;


@end

NS_ASSUME_NONNULL_END
