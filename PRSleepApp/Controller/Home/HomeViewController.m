//
//  HomeViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/2/18.
//  Copyright © 2020 priders. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    
}

- (void)setData{
    
    
}
- (void)initNav{
    
    UIScrollView *backImageSrollView = [[UIScrollView alloc]init];
   
    UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    NSString *fileImage = [[NSBundle mainBundle]pathForResource:@"member_daily_left_bg" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:fileImage];
    
    [backimageView setImage:[UIImage imageWithData:imageData]];
//    [backView addSubview:backImage];
//    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.tabBarController.navigationItem
//    self.tabBarController.tabBar.shadowImage = [[UIImage alloc]init];
    [self.view addSubview:backimageView];
//   
    
//    self.view
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
