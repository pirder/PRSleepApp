//
//  PRDragCardVew.m
//  PRSleepApp
//
//  Created by priders on 2020/3/20.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRDragCardView.h"

@interface PRDragCardView()

@property (nonatomic) NSInteger loadedIndex;

@property (nonatomic) BOOL finishedReset;

@property (nonatomic) BOOL moving; ///< 可以用方向替代, 暂时用着

@property (nonatomic) CGRect firstCardFrame; ///< 初始化时第一个Card的frame

@property (nonatomic) CGRect lastCardFrame; ///< 初始化时最后一个Card的frame

@property (nonatomic) CGPoint cardCenter;

@property (nonatomic) NSMutableArray *cards;
/** 记录滑动后当前的卡片 */
@property (nonatomic, weak) id currentCard;

@end


// 最多只显示3个
static const CGFloat kBoundaryRatio = 0.5f;
static const CGFloat kFirstCardScale  = 1.08f;
static const CGFloat kSecondCardScale = 1.04f;
// 与下一张图片的高度差
static const CGFloat kCellWidthEdage = 16.0f;
// 与下一张图片的宽度差
static const CGFloat kContainerEdage = 16.0f;
// 显示数量
static const CGFloat kVisibleCount = 3;


@implementation PRDragCardView

- (instancetype)initWithFrame:(CGRect)frame style:(PRDragStyle)style{
    self = [self initWithFrame:frame];
    self.style = style;
    self.remindNumber = 0;
    return self;
}

//- (NSInteger)remindNumber{
////    [self.subviews makeObjectsPerformSelector:@selector(<#selector#>)];
//    return 0;
//}
- (void)reloadData{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self defaultConfig];
    [self installNextItem];
    [self resetVisibleCards];
}
// MARK: - 初始化数据
- (void)defaultConfig {
    self.cards = [NSMutableArray array];
    self.finishedReset = NO;
    self.direction = PRDragDropDirectionDefault;
    self.loadedIndex = 0;
    self.moving = NO;
}

- (void)installNextItem {
   
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndragCardView:)] && [self.dataSource respondsToSelector:@selector(dragCardView:cellForRowAtIndex:)]) {
        NSInteger indexs = [self.dataSource numberOfIndragCardView:self];
        NSInteger preloadViewCont = indexs <= kVisibleCount ? indexs : kVisibleCount;
        //  -------------------------------------------------------------------------------------------------------
        // 在此需添加当前Card是否移动的状态A
        // 如果A为YES, 则执行当且仅当一次installNextItem, 用条件限制
        //  -------------------------------------------------------------------------------------------------------
        if (self.loadedIndex < indexs) {
            for (long int i = self.cards.count; i <  (self.moving ? preloadViewCont + 1: preloadViewCont); i++) {
                PRDragCardCell *cell = [self.dataSource dragCardView:self cellForRowAtIndex:self.loadedIndex];
                //                cell.frame = CGRectMake(kContainerEdage,
                //                                            kContainerEdage,
                //                                            self.frame.size.width  - kContainerEdage * 2, self.frame.size.height - kContainerEdage * 2);
                cell.frame = CGRectMake(0,
                                        0,
                                        self.frame.size.width ,
                                        self.frame.size.height );
                    if (self.loadedIndex >= 3) {
                        cell.frame = self.lastCardFrame;
                    } else {
                    CGRect frame = cell.frame;
                    
                    if (CGRectIsEmpty(self.firstCardFrame)) {
                        self.firstCardFrame = frame;
                        self.cardCenter = cell.center;
                    }
                }
                // TAG
                cell.tag = self.loadedIndex;
                [self addSubview:cell];
                [self sendSubviewToBack:cell]; // addSubview后添加sendSubviewToBack, 使Card的显示顺序倒置
                //  -----------------
                //  每次都会改变的
                //  -----------------
                // 添加新元素
                [self.cards addObject:cell];
                // 添加清扫手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
                [cell addGestureRecognizer:pan];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
                [cell addGestureRecognizer:tap];
                // 总数indexs, 计算以及加载到了第几个index
                self.loadedIndex += 1;
                // NSLog(@"loaded %ld card", (long)self.loadedIndex);
            }
        }
    } else {
        NSAssert(self.dataSource, @"PRDragCardViewDataSource can't nil");
    }
}

- (void)resetVisibleCards {
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [weakself originalLayout];
                     } completion:^(BOOL finished) {
                         weakself.finishedReset = YES;
                     }];
}

- (void)originalLayout {
    //    NSLog(@"%ld %ld", self.cards.count, self.remindNumber);
    if (self.delegate && [self.delegate respondsToSelector:@selector(residualQuantityReminder:)]) {
        if (self.cards.count <= self.remindNumber) {
            [self.delegate residualQuantityReminder:self.cards.count];
        }
    }
    for (int i = 0; i < self.cards.count; i++) {
        PRDragCardCell *cell = [self.cards objectAtIndex:i];
        cell.transform = CGAffineTransformIdentity;
        CGRect frame = self.firstCardFrame;
        switch (i) {
            case 0:{
                cell.frame = frame;
                cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, kFirstCardScale, kFirstCardScale);
            }break;
            case 1:{
                frame.origin.y = frame.origin.y + kCellWidthEdage;
                cell.frame = frame;
                cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, kSecondCardScale, kSecondCardScale);
            }break;
            case 2:{
                frame.origin.y = frame.origin.y + kCellWidthEdage * 2;
                cell.frame = frame;
                if (CGRectIsEmpty(self.lastCardFrame)) {
                    self.lastCardFrame = frame;
                }
            }break;
            default:
                break;
        }
        cell.originalTransform = cell.transform;
    }
    
    if (self.currentCard && self.delegate && [self.delegate respondsToSelector:@selector(dragCardView:
                                                                                         dragDropDirection:
                                                                                         widthRatio:
                                                                                         heightRatio:
                                                                                         currentCell:)]) {
//        [self.delegate dragCardView:self dragDropDirection:PRDragDropDirectionDefault widthRatio:0 heightRatio:0 currentCell:self.currentCard];
    }
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    if (!self.finishedReset) { return; }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.currentCard = gesture.view;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        PRDragCardCell *cell = (PRDragCardCell *)self.currentCard;
        CGPoint point = [gesture translationInView:self]; // translation: 平移 获取相对坐标原点的坐标
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cell.center = movedPoint;
        //        cell.transform = CGAffineTransformRotate(cell.originalTransform, (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x * (M_PI_4 / 4));
        cell.transform = CGAffineTransformMakeTranslation(15, 15);
        [gesture setTranslation:CGPointZero inView:self]; // 设置坐标原点位上次的坐标
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardView:
                                                                         dragDropDirection:
                                                                         widthRatio:
                                                                         heightRatio:
                                                                         currentCell:)]) {
            //  ---------------------------------------------------------------------------------------------
            //  做比例, 总长度(0 ~ self.cardCenter.x), 已知滑动的长度 (gesture.view.center.x - self.cardCenter.x)
            //  ratio用来判断是否显示图片中的"Like"或"DisLike"状态, 用开发者限定多少比例显示或设置透明度
            //  ---------------------------------------------------------------------------------------------
            float widthRatio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
            float heightRatio = (gesture.view.center.y - self.cardCenter.y) / self.cardCenter.y;
            // Moving
            [self judgeMovingState: widthRatio];
            //  ----------------------------------------
            //  左右的判断方法为: 只要 ratio_w > 0 就是Right
            //  ----------------------------------------
            if (widthRatio > 0) {
                self.direction = PRDragDropDirectionRight;
            } if (widthRatio < 0) {
                self.direction = PRDragDropDirectionLeft;
                
            } else if (widthRatio == 0) {
                self.direction = PRDragDropDirectionDefault;
            }
//            [self.delegate dragCardView:self dragDropDirection:self.direction widthRatio:widthRatio heightRatio:heightRatio currentCell:self.currentCard];
        }
    }
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled) {
        //  --------------------
        //  随着滑动的方向消失或还原
        //  --------------------
        float widthRatio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
        float moveWidth  = (gesture.view.center.x  - self.cardCenter.x);
        float moveHeight = (gesture.view.center.y - self.cardCenter.y);
        [self finishedPanGesture:gesture.view direction:self.direction scale:(moveWidth / moveHeight) disappear:fabs(widthRatio) > kBoundaryRatio];
    }
}

- (void)finishedPanGesture:(UIView *)cardView direction:(PRDragDropDirection)direction scale:(CGFloat)scale disappear:(BOOL)disappear {
    //  还原Original坐标
    //  移除最底层Card
    PRDragDropDirection realdirection = PRDragDropDirectionDefault;
    if (!disappear) { // 没有移除
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndragCardView:)]) {
            if (self.moving && self.loadedIndex < [self.dataSource numberOfIndragCardView:self]) {
                UIView *lastView = [self.cards lastObject];
                self.loadedIndex = lastView.tag;
                [lastView removeFromSuperview];
                [self.cards removeObject:lastView];
            }
            self.moving = NO;
            [self resetVisibleCards];
            
        }
    } else { // 移除了
        realdirection = self.direction;
        // 移除屏幕后
        // 1.删除移除屏幕的cardView
        // 2.重新布局剩下的cardViews
        NSInteger flag = direction == PRDragDropDirectionLeft ? -1 : 2;
        [UIView animateWithDuration:0.5f
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cardView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * flag, [UIScreen mainScreen].bounds.size.width * flag / scale + self.cardCenter.y);
                         } completion:^(BOOL finished) {
                             [cardView removeFromSuperview];
                         }];
        [self.cards removeObject:cardView];
        self.moving = NO;
        [self resetVisibleCards];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardView:dragDropDirection:dragEndWithIndex:)]) {
//
//        [self.delegate dragCardView:self dragDropDirection:realdirection dragEndWithIndex:cardView.tag];
    }
}
- (void)judgeMovingState:(CGFloat)scale {
    if (!self.moving) {
        self.moving = YES;
        [self installNextItem];
    } else {
        [self movingVisibleCards:scale];
    }
}
- (void)movingVisibleCards:(CGFloat)scale {
    scale = fabs(scale) >= kBoundaryRatio ? kBoundaryRatio : fabs(scale);
    CGFloat sPoor = kFirstCardScale - kSecondCardScale; // 相邻两个CardScale差值
    CGFloat tPoor = sPoor / (kBoundaryRatio / scale); // Transform中递加差值
    CGFloat yPoor = kCellWidthEdage / (kBoundaryRatio / scale); // y差值
    for (int i = 1; i < self.cards.count; i++) {
        PRDragCardCell *cell = [self.cards objectAtIndex:i];
        switch (i) {
            case 1:{
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kSecondCardScale, tPoor + kSecondCardScale);
                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
                cell.transform = translate;
            }break;
            case 2:{
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + 1, tPoor + 1);
                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
                cell.transform = translate;
                
            }break;
            case 3:{
                /*CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + (1 - sPoor), tPoor + (1 - sPoor));
                 CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, 2 * kCellWidthEdage);
                 cardView.transform = translate;*/
            } break;
            default:
                break;
        }
    }
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardView:didSelectIndex:)]) {
        [self.delegate dragCardView:self didSelectIndex:tap.view.tag];
    }
}

- (void)removeFormDirection:(PRDragDropDirection)direction {
    if (self.moving) {
        return;
    } else {
        CGPoint cardCenter = CGPointZero;
        CGFloat flag = 0;
        switch (direction) {
            case PRDragDropDirectionLeft:
                cardCenter = CGPointMake(-[UIScreen mainScreen].bounds.size.width / 2, self.cardCenter.y);
                flag = -1;
                break;
            case PRDragDropDirectionRight:
                cardCenter = CGPointMake([UIScreen mainScreen].bounds.size.width * 1.5, self.cardCenter.y);
                flag = 1;
                break;
            default:
                break;
        }
        UIView *firstView = [self.cards firstObject];
        [UIView animateWithDuration:0.35 animations:^{
            CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
            firstView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
            firstView.center = cardCenter;
        } completion:^(BOOL finished) {
            [firstView removeFromSuperview];
            [self.cards removeObject:firstView];
            [self installNextItem];
            [self resetVisibleCards];
        }];
    }
}

@end
