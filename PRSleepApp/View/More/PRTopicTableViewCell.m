//
//  PRTopicTableViewCell.m
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRTopicTableViewCell.h"
//#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PRTopicTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *topicsImageView;

@end

@implementation PRTopicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *PRTopicTableViewCellID = @"PRTopicTableViewCell";
    PRTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PRTopicTableViewCellID];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PRTopicTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    return cell;
}
- (void)setTopic:(PRTopics *)topic{
    _topic = topic;
    self.name.text =topic.name;
    self.time.text = topic.date;
    self.title.text = topic.title;
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:topic.avatarUrl] placeholderImage:[UIImage imageNamed:@"not_logged_in"]];
    [self.topicsImageView sd_setImageWithURL:[NSURL URLWithString:topic.topicImageUrl] placeholderImage:[UIImage imageNamed:@"downloadFailed"]];
}

@end
