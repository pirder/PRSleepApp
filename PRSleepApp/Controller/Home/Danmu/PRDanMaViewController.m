//
//  PRDanMaViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/4/1.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRDanMaViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import <AVOSCloud/AVOSCloud.h>
#import "PRBulletTalkViewController.h"
#define ScreenWidth  self.view.frame.size.width
#define ScreenHeight self.view.frame.size.height

@interface PRDanMaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) AVIMClient *tom;
@property (nonatomic, strong) AVUser *user;
@property (nonatomic, strong) NSMutableArray *messageArr;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <AVIMChatRoom *> *chatarr;
@end

@implementation PRDanMaViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //右滑返回手势
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]  initWithTarget: self  action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];

     [self lastTest];
    //刷新控件
    [self setUpRefresh];
    
    if (!_chatarr) {
        //
        [self queryRecentChatRooms];
    }

}



- (IBAction)addItemChat:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"进入聊天室前你需要选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建聊天室
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"创建一个新的聊天室" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"Input a Name" message:@"for ChatRoom" preferredStyle:UIAlertControllerStyleAlert];
        [alert1 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"ChatRoom's Name";
        }];
        [alert1 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }]];
        [alert1 addAction:[UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //创建聊天室具体操作
            NSString *name = alert1.textFields.firstObject.text;
            
            
            [self.tom createChatRoomWithName:name attributes:nil callback:^(AVIMChatRoom * _Nullable chatRoom, NSError * _Nullable error) {
                if (chatRoom && !error) {
                    AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:@"" attributes:nil];
                    [chatRoom sendMessage:textMessage callback:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded && !error) {
                            ///加进入数组
                            [self.chatarr addObject:chatRoom];
                            [self.tableView reloadData];
                        }
                        
                    }];
                }
            }];
            
        }]];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    }];
    
    
    [alert addAction:action];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"获取存在的聊天室" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        [self queryRecentChatRooms];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)addChat{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Action" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Create a chatroom" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alert addAction:action];
    [alert addAction:[UIAlertAction actionWithTitle:@"Get Recent ChatRooms" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)lastTest{
    
    self.user = [AVUser currentUser];
    //创建一个用户名的clinet
    self.tom = [[AVIMClient alloc] initWithClientId:self.user.username];
    [self.tom openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            
        }else{
            NSLog(@"打开链接错误信息-----%@",error);
        }
    }];
    self.tom.delegate = self;
//    self.tom.delegate = 
}

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
    [self queryRecentChatRooms];
    //    sleep(1);
    [refreshControl endRefreshing];
}

-(void)queryRecentChatRooms{
    
    AVIMConversationQuery *query = [self.tom conversationQuery];
    [query whereKey:@"tr" equalTo:@(YES)];
//    query.limit = 20;
    //    [query whereKey:@"name" equalTo:@"聊天室"];
    NSLog(@"打印聊天室信息%@",query);
        [query findConversationsWithCallback:^(NSArray<AVIMConversation *> * _Nullable conversations, NSError * _Nullable error) {
            //        for (AVIMConversation *con in conversations) {
            //            NSLog(@"打印聊天室信息 %@",con.name);
            //        }
            
            //            [self.chatarr setArray:conversations];
            if (!error) {
                
                 self.chatarr=conversations;
            }else{
                NSLog(@"错误信息--- %@",error);
            }
           
            //刷新列别
        }];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.tableView reloadData];
    });
 
   
   
    
}

- (IBAction)sendMessageBtn:(id)sender {
    //创建一个聊天对话
    /*
    [self.tom createConversationWithName:[NSString stringWithFormat:@"%@ & 987",self.user.username] clientIds:@[@"987"] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation * _Nullable conversation, NSError * _Nullable error) {
        AVIMTextMessage *message = [AVIMTextMessage messageWithText:@"起床" attributes:nil];
        [conversation sendMessage:message callback:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"发送成功");
            }
        }];
    }];
     */
    
    [self.tom createChatRoomWithName:@"聊天室" attributes:nil callback:^(AVIMChatRoom * _Nullable chatRoom, NSError * _Nullable error) {
        if (chatRoom && !error) {
            //
            AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:nil attributes:nil];
            [chatRoom sendMessage:textMessage callback:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded && !error) {
                    
                }
            }];
        }
    }];
    
    AVIMConversationQuery *query = [self.tom conversationQuery];
    [query whereKey:@"tr" equalTo:@(YES)];
//    [query whereKey:@"name" equalTo:@"聊天室"];
    NSLog(@"打印聊天室信息%@",query);
    [query findConversationsWithCallback:^(NSArray<AVIMConversation *> * _Nullable conversations, NSError * _Nullable error) {
        for (AVIMConversation *con in conversations) {
              NSLog(@"打印聊天室信息 %@",con.name);
        }
      
    }];

}
- (IBAction)acMessgaeBtn:(id)sender {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)test:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*!
 当前用户被邀请加入对话的通知。
 @param conversation － 所属对话
 @param clientId - 邀请者的 ID
 */
-(void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId{
    NSLog(@"%@", [NSString stringWithFormat:@"当前 clientId（Jerry）被 %@ 邀请，加入了对话",clientId]);
}

/*!
 接收到新消息（使用内置消息格式）。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    NSLog(@"%@", message.text); // Jerry，起床了！
    self.messageLabel.text = message.text;
    [self.messageArr addObject: message.text];
}

- (NSMutableArray *)messageArr{

    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}
- (NSMutableArray<AVIMChatRoom *> *)chatarr{

    if (!_chatarr) {
        _chatarr = [NSMutableArray array];
    }
    return _chatarr;
}


#pragma mark tableviw deletage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatarr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.chatarr[indexPath.row].name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ///- (void)joinWithCallback:(void (^)(BOOL, NSError *))callback
    AVIMChatRoom *chatroom = self.chatarr[indexPath.row];
    [chatroom joinWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        PRBulletTalkViewController *danma = [[PRBulletTalkViewController alloc]init];
        
        danma.chatroom = chatroom;
        
       
        self.definesPresentationContext = YES;
        [danma setModalPresentationStyle:UIModalPresentationOverFullScreen];
        [danma setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:danma animated:YES completion:nil];
    }];
    
    [chatroom queryMessagesFromServerWithLimit:10 callback:^(NSArray<AVIMMessage *> * _Nullable messages, NSError * _Nullable error) {
        for (AVIMTypedMessage *mess in messages) {
//            NSLog(@"信息为： ----%@",mess.text);
            
        }
    }];
}

///
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
