//
//  PRDragCardCell.h
//  PRSleepApp
//
//  Created by priders on 2020/3/20.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PRDragCardCell : UIView

@property(nonatomic) CGAffineTransform originalTransform;
- (void)initializeStyle;
@end

NS_ASSUME_NONNULL_END
