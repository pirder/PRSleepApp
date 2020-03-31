//
//  PRTopics.m
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRTopics.h"
#import <AVOSCloud/AVOSCloud.h>
@implementation PRTopics

+ (instancetype)initWithObject:(NSDictionary *)obj{
    
    PRTopics * topics = [[PRTopics alloc] init];
    
    topics.objectId =[obj objectForKey:@"objectId"];
//    NSLog(@"%@",[obj objectForKey:@"objectId"]);
   
    AVUser *owner =[obj objectForKey:@"owner"];
    topics.name =owner.username;
//     NSLog(@"%@",owner);
//    AVFile *userAvatar =[owner objectForKey:@"iamgeHead"];
    AVFile *userAvatar = [owner objectForKey:@"imageHead"];
    if (userAvatar) {
        topics.avatarUrl = userAvatar.url;
//        NSLog(@"头像地址%@",userAvatar.url);
    }
    
    NSDate *createdAt = [obj objectForKey:@"createdAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    topics.date = [dateFormatter stringFromDate:createdAt];
    
    //topics.price = [NSString stringWithFormat:@"%@",[obj objectForKey:@"price"]];
    topics.title = [obj objectForKey:@"title"];
    
    AVFile *file = [obj objectForKey:@"topicImage"];
    topics.topicImageUrl = file.url;
    
//    NSLog(@"%@",file.url);
//    NSLog(@"%@",topics);
    return topics;
}

-(CGFloat)cellHeight{
    //如果cell 的高度已经计算过,就直接返回
    if(_cellHeight) return _cellHeight;
    
    // cell高度 = 187+加文字高度
    _cellHeight = 225;
    CGSize labelSize =[self getSizeWithStr:self.title Width:[[UIScreen mainScreen] bounds].size.width-56 Font:15];//73
    _cellHeight+= labelSize.height;
//    NSLog(@"%d",_cellHeight);
    return _cellHeight;
}

- (CGSize) getSizeWithStr:(NSString *) str Width:(float)width Font:(float)fontSize
{
    NSDictionary * attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize tempSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attribute
                                        context:nil].size;
    return tempSize;
}
@end
