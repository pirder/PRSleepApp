//
//  PRSignupViewController.m
//  PRSleepApp
//
//  Created by priders on 2020/3/28.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRSignupViewController.h"
#import <AVOSCloud.h>

@interface PRSignupViewController ()<UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate>{
    BOOL toUploadImage;
    BOOL photoUploaded;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *sname;
@property (weak, nonatomic) IBOutlet UITextField *spassword;
@property (weak, nonatomic) IBOutlet UITextField *sNumber;
@property (weak, nonatomic) IBOutlet UIButton *signUpbtn;



@end

@implementation PRSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setTitle:@"注册"];
    // Do any additional setup after loading the view from its nib.
}
-(BOOL)checkPhoneNumber:(NSString *)phoneNumber {
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneNumber length]);
    NSArray *matches = [detector matchesInString:phoneNumber options:0 range:inputRange];
    
    BOOL verified = NO;
    
    if ([matches count] != 0) {
        // found match but we need to check if it matched the whole string
        NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
        
        if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
            // it matched the whole string
            verified = YES;
        }
        else {
            // it only matched partial string
            verified = NO;;
        }
    }
    
    return verified;
}
- (BOOL)validateEmail:(NSString *)email {
    
    NSString *emailRegEx=@"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest=[NSPredicate predicateWithFormat:@"SELF MATCHES  %@",emailRegEx];
    return [emailTest evaluateWithObject:email];
    
    
}

-(NSString *)checkUserDeatils{
    NSCharacterSet *whithNewChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *cemail = [self.email.text stringByTrimmingCharactersInSet:whithNewChars];
    NSString *username = [_sname.text stringByTrimmingCharactersInSet:whithNewChars];
    NSString *password = [self.spassword.text stringByTrimmingCharactersInSet:whithNewChars];
    NSString *phone = [self.sNumber.text stringByTrimmingCharactersInSet:whithNewChars];
    
     BOOL phoneVerified = [self checkPhoneNumber:phone];
     NSString *message = @"";
    
    
    
    if (![self validateEmail:cemail]) {
        message = @"邮箱格式有误";
    }
    
    if ([username length] < 6) {
        if ([message length]) message = [NSString stringWithFormat:@"%@, ", message];
        message = [NSString stringWithFormat:@"%@用户名太短啦", message];
    }
    if ([password length] < 6) {
        if ([message length]) message = [NSString stringWithFormat:@"%@, ", message];
        message = [NSString stringWithFormat:@"%@请谨慎设置密码", message];
    }
    if (!phoneVerified) {
        if ([message length]) message = [NSString stringWithFormat:@"%@, ", message];
        message = [NSString stringWithFormat:@"%@Invalid phone number", message];
    }
    return message;
}

- (IBAction)buttonSignUpTouched:(id)sender {
    
    NSString *err = [self checkUserDeatils];
    if (![err length]) {
        NSCharacterSet *whithNewChars = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *cemail = [self.email.text stringByTrimmingCharactersInSet:whithNewChars];
        NSString *username = [_sname.text stringByTrimmingCharactersInSet:whithNewChars];
        NSString *password = [self.spassword.text stringByTrimmingCharactersInSet:whithNewChars];
        NSString *phone = [self.sNumber.text stringByTrimmingCharactersInSet:whithNewChars];
        
        AVUser *user = [AVUser user];
        [user setUsername:username];
        [user setPassword:password];
        [user setEmail:cemail];
         
//        user[@"phone"] = phone;
        [user setMobilePhoneNumber:phone];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self checkIfToUploadImage];
                [self.delegate successSignUpAutoLogin:user];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
    else{
        [[[UIAlertView alloc] initWithTitle:@"注册失败"
                                    message:[error userInfo][@"error"]
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
    }
        }];
        
        //测试一定成功
//         [self.delegate successSignUpAutoLogin:user];
//         [self dismissViewControllerAnimated:NO completion:nil];
//          [UIAlertController alertControllerWithTitle:@"注册失败" message:err preferredStyle:UIAlertControllerStyleAlert];
        
        
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"注册失败"
                                    message:err
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
//        [UIAlertController alertControllerWithTitle:@"注册失败" message:err preferredStyle:UIAlertControllerStyleAlert];
        
    }
    
}
- (IBAction)imagebtnSelect:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    [picker setDelegate:self];
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


//保存图片
-(void)checkIfToUploadImage{
    if(toUploadImage) {
        AVUser *currentUser = [AVUser currentUser];
        NSString *strImageName = [NSString stringWithFormat:@"%@.png",currentUser.objectId];
        
        NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
        AVFile *imageFile = [AVFile fileWithData:imageData name:strImageName];
        [imageFile uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                //   photoUploaded  = YES;
                [currentUser setObject:imageFile forKey:@"imageHead"];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded , NSError *error){
                    if (!error){
                        //上传成功
                        //   photoUploaded = YES;
                    }else{
                        //   photoUploaded = NO;
                        //上传失败
                    }
                    
                    //成功跳转
        }];
            }
        }];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIImagePickerController Delegage


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    toUploadImage = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    self.imageView.image = chosenImage;
    [self.imageView setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
