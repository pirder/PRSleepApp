//
//  HomeViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/2/18.
//  Copyright © 2020 priders. All rights reserved.
//

#import "HomeViewController.h"
#import "PRDragCardView.h"
#import "PRFateCell.h"
#import "PRDragConfig.h"
#import "PRHomeSleepViewController.h"

////横向比例
#define WidthScale(number)   ([UIScreen mainScreen].bounds.size.width/375.*(number))
////纵向比例
#define HeightScale(number)  ([UIScreen mainScreen].bounds.size.height*(number)/667.)
#define CCWidth  [UIScreen mainScreen].bounds.size.width
#define CCHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface HomeViewController ()<PRDragCardViewDelegate,PRDragCardViewDataSource,PRHomeSleepViewControllerDelegate>

@property (nonatomic,strong) PRDragCardView *contentView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self initNav];
    [self setUI];
    [self loadData];
    
}
- (void)setData{
}
- (void)initNav{
    
    UIScrollView *backImageSrollView = [[UIScrollView alloc]init];
   
    UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    NSString *fileImage = [[NSBundle mainBundle]pathForResource:@"member_daily_left_bg" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:fileImage];
    
    NSURL *audioUrl = [[NSBundle mainBundle]URLForResource:@"preset_focus_ocean.m4a" withExtension:nil];
    NSLog(@"播放音乐%@",audioUrl.absoluteString);
    [backimageView setImage:[UIImage imageWithData:imageData]];
//    [backView addSubview:backImage];
//    [[[self.navigationController.navigationBar subviews] firstObject] setAlpha:0];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.tabBarController.navigationItem
//    self.tabBarController.tabBar.shadowImage = [[UIImage alloc]init];
    [self.view addSubview:backimageView];

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

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    formatter.AMSymbol = @"上午";
//    formatter.PMSymbol = @"下午";
    //    [formatter setDateFormat:@"aaa"];
    
    //    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    
    
    [formatter setDateFormat:@"HH"];

    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    

        //--将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    int time = [currentTimeString intValue];
    if (time>17&&time<=19) {
        return @"傍晚";
    }else if(time<=06){
        return @"晚上";
    } else{
        return @"早上";
            }

//    return currentTimeString;
}


- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (PRDragCardView *)contentView{
    if (!_contentView) {
//        CGFloat w = WidthScale(326);
//        CGFloat h = HeightScale(439);
//        CGFloat x = (CCWidth-w)/2;
        _contentView = [[PRDragCardView alloc] initWithFrame:CGRectMake(0, 0, CCWidth, CCHeight) style: PRDragStyleUpOverlay];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.remindNumber = 1;
    }
    return _contentView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        CGFloat w = WidthScale(326);
        CGFloat h = 40;
        CGFloat x = (CCWidth-w)/2+5;
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+20, 80, w, h)];
        //        _topLabel.font = [UIFont systemFontOfSize:28];
        _topLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:28];
        //        Helvetica TrebuchetMS
        _topLabel.text = [NSString stringWithFormat:@"%@好",self.getCurrentTime];
        
        _topLabel.textColor = [UIColor whiteColor];
    }
    return _topLabel;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-100.0, kScreenHeight-120.0-60.0, 60.0, 60.0)];
//        setFrame:CGRectMake(kScreenWidth/2-30.0, kScreenHeight-49.0-60.0, 60.0, 60.0)];
        [_leftBtn setTitle:@"睡眠" forState:UIControlStateNormal];
//        [_leftBtn setTitle:@"摸我干啥" forState:UIControlStateHighlighted];
        
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn.layer setBorderWidth:0.5];
        [_leftBtn.layer setBorderColor:[UIColor darkGrayColor].CGColor];
        [_leftBtn.layer setCornerRadius:30.0];
        [_leftBtn.layer setMasksToBounds:YES];
        
        [_leftBtn addTarget:self action:@selector(buttonSleep) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftBtn;
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

-(void)buttonSleep{
    PRHomeSleepViewController  *menu = [[PRHomeSleepViewController alloc] init];
    [menu setDelegate:self];
    [menu setModalPresentationStyle:UIModalPresentationFullScreen];
    [menu setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:menu animated:YES completion:nil];
    
    NSLog(@"点击成功");
}
- (void)buttonTalk{
    NSLog(@"论坛");
}

- (void)setUI{
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.leftBtn];
     [self.view addSubview:self.rightBtn];
}


// MARK: - 请求数据
- (void)loadData {
    [self.dataSources removeAllObjects];
    for(int i = 0; i < 3; i++){
        NSString *name = [NSString stringWithFormat:@"image_%d.jpg",i + 1];
        [self.dataSources addObject:name];
    }
    [self.contentView reloadData];
}

- (NSInteger)numberOfIndragCardView:(PRDragCardView *)dragCardView{
    return self.dataSources.count;
}

- (PRDragCardCell *)dragCardView:(PRDragCardView *)dragCardView cellForRowAtIndex:(NSInteger)index{
    PRFateCell *cell = [PRFateCell hw_loadViewFromNib];
    NSString *imageName = self.dataSources[index];
    cell.type = FateCellTypeDefault;
    cell.imageName = imageName;
    cell.seeClickBlcok = ^{
        NSLog(@"");
    };
    return cell;
    

}

- (void)residualQuantityReminder:(NSInteger)remindNumber {
    if (remindNumber == 1)  {
        NSLog(@"请求数据了");
    } else if (remindNumber == 0) {
        NSLog(@"切换下一组了");
        [self loadData];
    }
}
- (void)PRMenuDidTapOnBackground:(PRHomeSleepViewController *)sleepMenu{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
