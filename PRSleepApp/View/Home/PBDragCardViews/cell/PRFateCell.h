//
//  PRFateCell.h
//  PRSleepApp
//
//  Created by priders on 2020/3/22.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRDragCardCell.h"
typedef enum : NSUInteger {
    FateCellTypeDefault = 0,
    FateCellTypeLike,
    FateCellTypeDislike,
} FateCellType;

NS_ASSUME_NONNULL_BEGIN

@interface PRFateCell : PRDragCardCell
/** 图片名 */
@property(nonatomic, strong) NSString *imageName;

/** 选择回调 */
@property(nonatomic, copy) void(^seeClickBlcok)(void);

/** cell的x类型 */
@property(nonatomic, assign) FateCellType type;

+ (id)hw_loadViewFromNib;
@end

NS_ASSUME_NONNULL_END
