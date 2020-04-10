//
//  PRTopics.h
//  PRSleepApp
//
//  Created by priders on 2020/3/29.
//  Copyright © 2020 priders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRTopics : NSObject

+(instancetype)initWithObject:(NSDictionary *)obj;

@property (nonatomic,copy) NSString *objectId;
/** 用户名 */
@property (nonatomic,copy) NSString *name;
/** 用户头像 */
@property (nonatomic,copy) NSString *avatarUrl;
/** 发布日期 */
@property (nonatomic,copy) NSString *date;
/** 心经描述 */
@property (nonatomic,copy) NSString *title;
/** 心经图片 */
@property (nonatomic,copy) NSString *topicImageUrl;
/** cell 的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
