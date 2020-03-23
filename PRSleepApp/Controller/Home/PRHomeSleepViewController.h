//
//  PRHomeSleepViewController.h
//  PRSleepApp
//
//  Created by priders on 2020/3/23.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PRHomeSleepViewController;


@protocol PRHomeSleepViewControllerDelegate <NSObject>

//点击空白地方取消
- (void)PRMenuDidTapOnBackground:(PRHomeSleepViewController *)sleepMenu;

//

@end

@interface PRHomeSleepViewController : UIViewController

@property (nonatomic,assign) id<PRHomeSleepViewControllerDelegate>delegate;
@property (nonatomic,copy) NSArray *menuItemArr;
//初始化
//- (instancetype)initWithMenus:(NSArray *)menus;


@end

NS_ASSUME_NONNULL_END
