//
//  PRLoginViewController.h
//  PRSleepApp
//
//  Created by priders on 2020/3/27.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PRLoginViewControllerDelegate <NSObject>

- (void) testLoadData;
- (void) removeNowController;

@end

@interface PRLoginViewController : UIViewController
@property (nonatomic,assign) id<PRLoginViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
