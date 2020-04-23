//
//  PRDragCardVew.h
//  PRSleepApp
//
//  Created by priders on 2020/3/20.
//  Copyright © 2020 priders. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRDragCardCell.h"
#import "PRDragConfig.h"
@class PRDragCardView;

@protocol PRDragCardViewDelegate <NSObject>
@optional

//- (void)dragCardView:(PRDragCardVew * _Nonnull)dragCardView
//        dragDropDire

//结束时候
- (void)dragCardView:(PRDragCardView * _Nonnull)dragCardView
   dradDropDirection:(PRDragDropDirection)dragDropDireceton
    dragEndWithIndex:(NSInteger)index;
/**
 点击Cell回调
 @param dragCardView dragCardView
 @param index 当前的角标
 */
- (void)dragCardView:(PRDragCardView * _Nonnull)dragCardView
      didSelectIndex:(NSInteger)index;

/** 剩余数量提示 */
- (void)residualQuantityReminder:(NSInteger)remindNumber;
@end

@protocol PRDragCardViewDataSource <NSObject>
@required
- (PRDragCardCell * _Nonnull)dragCardView:(PRDragCardView * _Nonnull)dragCardView
                        cellForRowAtIndex:(NSInteger)index;

- (NSInteger)numberOfIndragCardView:(PRDragCardView * _Nonnull)dragCardView;



@end
NS_ASSUME_NONNULL_BEGIN

@interface PRDragCardView : UIView

@property (nonatomic,weak) id<PRDragCardViewDelegate>delegate;

@property (nonatomic,weak) id<PRDragCardViewDataSource>dataSource;

@property (nonatomic,assign) PRDragStyle style;
@property (nonatomic,assign) PRDragDropDirection direction;

@property (nonatomic,assign) NSInteger remindNumber;


-(instancetype)initWithFrame:(CGRect)frame style:(PRDragStyle)style;
//-(void)removeFormDirection:(PRDragDropDirection)direction;
-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
