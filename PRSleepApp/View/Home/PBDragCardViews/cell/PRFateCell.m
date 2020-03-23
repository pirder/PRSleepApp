//
//  PRFateCell.m
//  PRSleepApp
//
//  Created by priders on 2020/3/22.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRFateCell.h"
#import <AVFoundation/AVFoundation.h>
@interface PRFateCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong,nonatomic) AVAudioPlayer *player;
@property (nonatomic) BOOL playIsOrNot;

@end

@implementation PRFateCell

//-(void)setImageBtn:(NSString *)imageName{
//      _imageName = imageName;
//    [self.imageBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
//    [self.imageBtn setTitle:@"stop" forState:UIControlStateNormal];
    [self setPlayIsOrNot:YES];
    [self.imageBtn setImage:[UIImage imageNamed:@"playBTN"] forState:UIControlStateNormal];
//    [self playBtnClick:[self imageBtn]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)seeBtnClick:(id)sender {
    if (self.seeClickBlcok) {
        self.seeClickBlcok();
    }
}
- (IBAction)playBtnClick:(UIButton *)sender {
    NSLog(@"%@",sender.titleLabel.text);
    
    if ([self playIsOrNot]) {
//        [sender.titleLabel.text  isEqual: @"stop"]
        NSLog(@"%@",_imageName);
        NSString *resouerce = [NSString stringWithFormat:@"%@%@",[_imageName substringToIndex:8],@"m4a"];
        NSLog(@"%@",resouerce);
        NSURL *audioUrl = [[NSBundle mainBundle]URLForResource:resouerce withExtension:nil];
        
        //        NSLog(@"播放音乐%@",audioUrl.absoluteString);
        AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:audioUrl error:nil];
        //    player.play;
        _player = player;
        [_player setNumberOfLoops:-1];
        [_player prepareToPlay];
        [_player play];
//        [sender setTitle:@" " forState:UIControlStateNormal];
        [self setPlayIsOrNot:NO];
        [sender setImage:nil forState:UIControlStateNormal];
    }
    else{
        [_player stop];
//        [sender setTitle:@"stop" forState:UIControlStateNormal];
        [self setPlayIsOrNot:YES];
        [sender setImage:[UIImage imageNamed:@"playBTN"] forState:UIControlStateNormal];
    }
    
    
}

- (void)setType:(FateCellType)type {
//    if (_type == type) {return;}
//    _type = type;
//    switch (type) {
//        case FateCellTypeLike:
//            _label.text = @"喜欢";
//            NSLog(@"拖拽中-喜欢");
//            break;
//        case FateCellTypeDislike:
//            _label.text = @"不喜欢";
//            NSLog(@"拖拽中-不喜欢");
//            break;
//        default:
//            _label.text = @"";
//            break;
//    }
}



+ (id)hw_loadViewFromNib {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    if (view) {
        
        return view;
    } else {
        return [[UIView alloc] init];
    }
}
@end
