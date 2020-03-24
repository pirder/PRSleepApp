//
//  PRDataPicker.h
//  PRSleepApp
//
//  Created by priders on 2020/3/24.
//  Copyright © 2020 priders. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@interface PRDataPicker : UIView
//
//@end
@protocol PRDatePickerDelegate <NSObject>

-(void)dateSelected:(NSDate *)date actionIndex:(NSInteger )index;

-(void)animationFinished;

@end

@interface PRDataPicker : UIView

@property(nonatomic,assign)NSDate *date;
@property(nonatomic,weak) id<PRDatePickerDelegate> delegate;

-(instancetype)initDatePicker:(CGRect) rect defaultDate:(NSDate *) defaultDate selectFutureDate:(BOOL)select;

-(void)animationFinished;

-(void)show;

-(void)dismiss;

@end



NS_ASSUME_NONNULL_END
