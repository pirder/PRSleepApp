//
//  PRTopicTableViewCell.h
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRTopics.h"
NS_ASSUME_NONNULL_BEGIN

@interface PRTopicTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) PRTopics  * topic;

@end

NS_ASSUME_NONNULL_END
