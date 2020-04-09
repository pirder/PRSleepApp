//
//  PRMyTopicTableViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/4/9.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRMyTopicTableViewController.h"
#import "PRTopicTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PRPushTopicViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PRMyTopicTableViewController ()

@end

@implementation PRMyTopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的心经";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //右滑返回手势
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]  initWithTarget: self  action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [query whereKey:@"owner" equalTo:[AVUser currentUser]];
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

#pragma mark - Table view data source

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
    NSLog(@"%@",self.topicsArr[indexPath.row].title);
    PRPushTopicViewController *signup = [[PRPushTopicViewController alloc]init];
    [signup setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [signup setModalPresentationStyle:UIModalPresentationFullScreen];
    
    [signup setTitle:self.topicsArr[indexPath.row].title];
    [signup setTopID:self.topicsArr[indexPath.row].objectId];
    [signup setTopicsImageUrl:self.topicsArr[indexPath.row].topicImageUrl];
    
    [self presentViewController:signup animated:YES completion:nil];
    
    
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

//    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        //        [self.tableView reloadData];
//        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
//        // 退出编辑模式
//        self.tableView.editing = NO;
//    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *OId = self.topicsArr[indexPath.row].objectId;
        
        AVObject *todo = [AVObject objectWithClassName:@"Topics" objectId:OId];
        [todo deleteInBackground];
        [self.topicsArr removeObjectAtIndex:indexPath.row];
       
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    return @[action1];

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
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
