//
//  PRSignupViewController.h
//  PRSleepApp
//
//  Created by priders on 2020/3/28.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud.h>
NS_ASSUME_NONNULL_BEGIN
@protocol PRSignupViewControllerDelegate <NSObject>

-(void)successSignUpAutoLogin:(AVUser *)Signuser;

@end
@interface PRSignupViewController : UIViewController

@property (nonatomic,assign) id<PRSignupViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
