//
//  PRDragConfig.h
//  PRSleepApp
//
//  Created by priders on 2020/3/20.
//  Copyright © 2020 priders. All rights reserved.
//

#ifndef PRDragConfig_h
#define PRDragConfig_h
typedef enum PRDragDropDirection : NSInteger {
    PRDragDropDirectionDefault     = 0,
    PRDragDropDirectionLeft        = 1 << 0,
    PRDragDropDirectionRight       = 1 << 1
}PRDragDropDirection;

typedef NS_OPTIONS(NSInteger, PRDragStyle) {
    PRDragStyleUpOverlay   = 0,
    PRDragStyleDownOverlay = 1
};

////CG
//static const CGFloat kBoundaryRatio = 0.5f;
//static const CGFloat kFirstCardScale  = 1.08f;
//static const CGFloat kSecondCardScale = 1.04f;
//// 与下一张图片的高度差
//static const CGFloat kCellWidthEdage = 16.0f;
//// 与下一张图片的宽度差
//static const CGFloat kContainerEdage = 16.0f;
//// 显示数量
//static const CGFloat kVisibleCount = 3;




#endif /* PRDragConfig_h */
