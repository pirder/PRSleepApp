//
//  MoreViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import "MoreViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PRTopics.h"
#import "PRTopicTableViewCell.h"
#import <PRPushTopicViewController.h>
#import "PRDanMaViewController.h"
@interface MoreViewController ()
@property (nonatomic,strong)NSMutableArray <PRTopics *> *topicsArr;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"心经站";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setNavigationIterm];
    
    //刷新控件
        [self setUpRefresh];
    
    //     UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //     backView.backgroundColor = [UIColor whiteColor];
    //     [self.view addSubview:backView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.topicsArr removeAllObjects];
    [self queryTopics];
    [self.tableView reloadData];
    
}
-(void)queryTopics{
    
    AVQuery *query = [AVQuery queryWithClassName:@"Topics"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"owner"];
    [query includeKey:@"topicImage"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (NSDictionary *object in objects) {
                PRTopics *top = [PRTopics initWithObject:object];
                NSLog(@"%@",object);
                [self.topicsArr addObject: top];
            }
        }
         [self.tableView reloadData];
    }];
   
//    NSLog(@"%d",self.topicsArr.count);
}

-(void)setNavigationIterm{


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发心经" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageAbout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"聊天" style:UIBarButtonItemStylePlain target:self action:@selector(addFriends)];
    //    [self setUpCenterTitle];
}
-(void)sendMessageAbout{
    PRPushTopicViewController *signup = [[PRPushTopicViewController alloc]init];
    [signup setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [signup setModalPresentationStyle:UIModalPresentationFullScreen];
    //    [signup setDelegate:self];
    [self presentViewController:signup animated:YES completion:nil];
}
-(void)addFriends{
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


//-(void)sendMessageAbout{
//    PRPushTopicViewController *vc = [[PRPushTopicViewController alloc]init];
//    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self presentViewController:vc animated:YES completion:nil];
//}

-(void)setUpRefresh{
    //下拉刷新
    UIRefreshControl *refreshController = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshController];

    //监听
    [refreshController addTarget:self action:@selector(refreshControlStateChange:) forControlEvents:UIControlEventValueChanged];
    //刷新状态
    [refreshController beginRefreshing];

    //加载数据
    [self refreshControlStateChange:refreshController];

    //上拉控件
}

-(void) refreshControlStateChange:(UIRefreshControl *)refreshControl{
    [self.tableView reloadData];
//    sleep(1);
    [refreshControl endRefreshing];
}


//-(void)setUpCenterTitle{
//    //中间标题设定
//
//    [self setUpUserInfo];
//}
//
//-(void)setUpUserInfo{
//    //设置用户信息
//    AVUser *currentUser = [AVUser currentUser];
//    if (currentUser !=nil) {
//        //保存用户信息
//        NSLog(@"%@",currentUser);
//    }else{
//        NSLog(@"信息获取失败");
//    }
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -加载数据
-(void)loadNewStatuses:(UIRefreshControl *)refreshControl{
    /*
     实际定义了一个弱引用性质的替身.
     这个一般在使用block时会用到,因为block会copy它内部的变量,使用__weak性质的self替代self,可以切断block对self的引用.避免循环引用.
     typeof()是根据括号里的变量,自动识别变量类型并返回该类型
     */
    //    typeof(self) __weak weakSelf = self;
    
    
}

#pragma mark --shuju
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%d",self.topicsArr.count);
    return  self.topicsArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    PRTopicTableViewCell *cell = [PRTopicTableViewCell cellWithTableView:tableView];
//    //    [cell setTopic: self.topicsArr[indexPath.row] ];
//    cell.topic = self.topicsArr[indexPath.row];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRTopicTableViewCell *cell = [PRTopicTableViewCell cellWithTableView:tableView];
    //    [cell setTopic: self.topicsArr[indexPath.row] ];
    cell.topic = self.topicsArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    NSLog(@"%@",self.topicsArr[indexPath.row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.topicsArr[indexPath.row].cellHeight;
}
-(NSMutableArray<PRTopics *> *)topicsArr{
    if (!_topicsArr) {
        _topicsArr =[NSMutableArray array];
    }
    return _topicsArr;
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
@end


//#pragma mark - Table view data source



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


