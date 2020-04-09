//
//  PRBulletTalkViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/4/9.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRBulletTalkViewController.h"
#import "PRBulletView.h"
#import "PRBulletManager.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface PRBulletTalkViewController ()

@property (weak, nonatomic) IBOutlet UITextField *sendmagTextF;
@property (weak, nonatomic) IBOutlet UILabel *chatronnName;
@property (nonatomic,strong) PRBulletManager *manager;
@end

@implementation PRBulletTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chatronnName.text = self.chatroom.name;
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(test:) userInfo:nil repeats:YES];
    
    self.manager = [[PRBulletManager alloc] init];
    __weak typeof(self)weakSelf = self;
    [self.manager setGenerateViewBlock:^(PRBulletView *view) {
        [weakSelf addBulletView:view];
    }];
    [self.manager start];
    
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]  initWithTarget: self  action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
}

-(void)didClickStart
{
    [self.manager start];
}

-(void)didClickStop
{
    [self.manager stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addBulletView:(PRBulletView *)view
{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(screenW, 100 + view.trajectory * 50, view.frame.size.width, view.frame.size.height);
    [self.view addSubview:view];
    
    [view startAnimation];
}

- (IBAction)sendBtn:(id)sender {
    //    AVIMChatRoom *con = self.chatroom;
    NSString *messageStr = self.sendmagTextF.text;
    AVIMMessage *message = [AVIMMessage messageWithContent:messageStr];
    [self.chatroom sendMessage:message callback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"发送成功加入数组");
            //            [self.manager.dataSource addObject:messageStr];
        }
    }];
    self.sendmagTextF.text = nil;
    
}

- (IBAction)test:(id)sender {
    /*!
     获取该会话的最近 limit 条消息。
     @param limit 返回结果的数量，默认 20 条，最多 1000 条。
     @param callback 查询结果回调。
     
     - (void)queryMessagesWithLimit:(NSUInteger)limit
     callback:(void (^)(NSArray<AVIMMessage *> * _Nullable messages, NSError * _Nullable error))callback;
     */
    [self.chatroom queryMessagesWithLimit:10 callback:^(NSArray<AVIMMessage *> * _Nullable messages, NSError * _Nullable error) {
        NSMutableArray *arr = [NSMutableArray array];
        for (AVIMTypedMessage *mess in messages) {
            NSLog(@"信息为： ----%@",mess.content);
            if(self.manager.dataSource.count >= 15){
                [arr removeAllObjects ];
            }
            //            [self.manager.dataSource addObject:mess.content ];
            [arr addObject:mess.content];
        }
        self.manager.dataSource=arr;
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
//    NSLog(@"%@", message.text); // Jerry，起床了！
//}
//- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId {
//    NSLog(@"%@", [NSString stringWithFormat:@"%@ 加入到对话，操作者为：%@",[clientIds objectAtIndex:0],clientId]);
//}


///
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:^{
        [self didClickStop];
    }];
}

@end
