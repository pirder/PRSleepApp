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

@interface PRBulletTalkViewController (){
    NSTimer *time;
}

@property (weak, nonatomic) IBOutlet UITextField *sendmagTextF;
@property (weak, nonatomic) IBOutlet UILabel *chatronnName;
@property (nonatomic,strong) PRBulletManager *manager;
@end

@implementation PRBulletTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
  
    self.chatronnName.text = self.chatroom.name;
    
    time = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(test:) userInfo:nil repeats:YES];
    
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
            [self.manager stop];
            [self.manager start];
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



/*
 NSTimer循环引用属于相互循环使用
 在控制器内，创建NSTimer作为其属性，由于定时器创建后也会强引用该控制器对象，那么该对象和定时器就相互循环引用了。
 如何解决呢？
 这里我们可以使用手动断开循环引用：
 如果是不重复定时器，在回调方法里将定时器invalidate并置为nil即可。
 如果是重复定时器，在合适的位置将其invalidate并置为nil即可
*/
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self didClickStop];
        [self.chatroom quitWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
            [time invalidate];
        }];
        
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    CGFloat duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect frame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat offsetY = frame.origin.y - self.view.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, offsetY);
        }];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.sendmagTextF isExclusiveTouch]) {
        [self.sendmagTextF  resignFirstResponder];
    }
}

@end
