//
//  PRBulletManager.h
//  PRSleepApp
//
//  Created by priders on 2020/4/9.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PRBulletView;

@interface PRBulletManager : NSObject
@property (nonatomic,copy) void(^generateViewBlock)(PRBulletView *view);
/** 弹幕的数据来源*/
@property (nonatomic,strong) NSMutableArray *dataSource;
-(void)start;

-(void)stop;
@end

NS_ASSUME_NONNULL_END
