//
//  PRPushTopicViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/3/30.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRPushTopicViewController.h"
#import <AVOSCloud.h>
#import <SDWebImage/SDWebImage.h>

@interface PRPushTopicViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *topicsTextF;
@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;

@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;
@property (weak, nonatomic) IBOutlet UIButton *send;

@end

@implementation PRPushTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topicsTextF.delegate = self;
//    self.topicsTextF.text = @"";
    self.navigationItem.title = @"发布新商品";
    
    self.topicsTextF.text = self.title;
    
    if (self.topicsImageUrl) {
        [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:self.topicsImageUrl] placeholderImage:[UIImage imageNamed:@"downloadFailed"]];
        UIImage *image = self.topicImageView.image;
        NSData *imageData;
        if (UIImagePNGRepresentation(image)) {
            imageData = UIImagePNGRepresentation(image);
        }else{
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        self.imageData = imageData;
    }
}


- (IBAction)pushTopicbtn:(id)sender {
    NSString *prTopicsTitle = self.topicsTextF.text;
    AVObject *topicsObject = nil;
    if (self.topID) {
        topicsObject = [AVObject objectWithClassName:@"Topics" objectId:self.topID];
    }else{
        //ADD
        topicsObject = [AVObject objectWithClassName:@"Topics"];
    }
        [topicsObject setObject:prTopicsTitle forKey:@"title"];
        // owner 字段pointer；类型 指向用户表
        AVUser *currentu = [AVUser currentUser];
        [topicsObject setObject:currentu forKey:@"owner"];
        
        AVFile *file = [AVFile fileWithData:self.imageData];
        [topicsObject setObject:file forKey:@"topicImage"];
        
        [self.send setEnabled:NO];
        
        [topicsObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSLog(@"发布成功");
                //提示
                [self dismissViewControllerAnimated:YES completion:nil];
                [self alertMessage:@"发布成功"];
                [self.send setEnabled:YES];
            }else{
                NSLog(@"保存新物品出错%@",error.localizedDescription);
            }
        }];
}
- (IBAction)cancelPushBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pickPhotobtn:(id)sender {
    [self selectImageWithPickertype:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (IBAction)takePhotobtn:(id)sender {
    [self selectImageWithPickertype:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.topicImageView.image = image;
    NSData *imageData;
    if (UIImagePNGRepresentation(image)) {
        imageData = UIImagePNGRepresentation(image);
    }else{
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    self.imageData = imageData;
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    
}
#pragma mark - Cancelpick
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark select picture
-(void)selectImageWithPickertype:(UIImagePickerControllerSourceType)sourceType {
    sleep(1);
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = sourceType;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
//    else{
//        [self alertMessage:@"图片库不可用或当前设备没有摄像头"];
//    }
}

#pragma mark -  Private Methods
-(void)alertMessage:(NSString *)message{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
    }
    return _imagePicker;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
//    textView.text = @"";
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.topicsTextF isExclusiveTouch]) {
        [self.topicsTextF  resignFirstResponder];
    }
}

@end
