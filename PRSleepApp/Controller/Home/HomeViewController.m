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
#import <AVOSCloud/AVOSCloud.h>
#import "PRDanMaViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

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
    [self initNav];

    [self setUI];
    [self loadData];
    
}
- (void)initNav{
   
    UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CCWidth, CCHeight)];
    NSString *fileImage = [[NSBundle mainBundle]pathForResource:@"member_daily_left_bg" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:fileImage];
    
    NSURL *audioUrl = [[NSBundle mainBundle]URLForResource:@"preset_focus_ocean.m4a" withExtension:nil];
    NSLog(@"播放音乐%@",audioUrl.absoluteString);
    [backimageView setImage:[UIImage imageWithData:imageData]];
    [self.view addSubview:backimageView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //--将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    int time = [currentTimeString intValue];
     NSLog(@"%d",time);
    if (time>17&&time<=19) {
        return @"傍晚";
    }else if(time<=06){
        return @"晚上";
    } else if(time>13){
        return @"下午";
    } else{
        return @"早上";
            }
}


- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (PRDragCardView *)contentView{
    if (!_contentView) {
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
        _topLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:28];
        _topLabel.text = [NSString stringWithFormat:@"%@好",self.getCurrentTime];
        _topLabel.textColor = [UIColor darkGrayColor];
    }
    return _topLabel;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-100.0, kScreenHeight-120.0-60.0, 60.0, 60.0)];
        [_leftBtn setTitle:@"睡眠" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
        [_rightBtn setTitle:@"畅聊" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
    //背景
    self.definesPresentationContext =YES;
    [menu setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [menu setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:menu animated:YES completion:nil];
    NSLog(@"点击成功");
}
#pragma mark 聊天室
- (void)buttonTalk{
    if([AVUser currentUser]){
        NSLog(@"弹幕聊天室");
        PRDanMaViewController *danma = [[PRDanMaViewController alloc]init];
        self.definesPresentationContext = YES;
        [danma setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [danma setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:danma animated:YES completion:nil];
    }else{
        UITabBarController *tabbarCtrl = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController ;
        //    UINavigationController *navCtrl = tabbarCtrl.selectedViewController;
        [tabbarCtrl setSelectedIndex:2];
    }
    
    
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
    for(int i = 0; i < 4; i++){
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
