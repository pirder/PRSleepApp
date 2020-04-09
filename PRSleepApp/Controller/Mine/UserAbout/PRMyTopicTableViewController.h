//
//  PRMyTopicTableViewController.h
//  PRSleepApp
//
//  Created by priders on 2020/4/9.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRTopics.h"
NS_ASSUME_NONNULL_BEGIN

@interface PRMyTopicTableViewController : UITableViewController
@property (nonatomic,strong)NSMutableArray <PRTopics *> *topicsArr;
@end

NS_ASSUME_NONNULL_END
