//
//  PRDataPicker.m
//  PRSleepApp
//
//  Created by priders on 2020/3/24.
//  Copyright © 2020 priders. All rights reserved.
//

#import "PRDataPicker.h"
static const int HEIGHT = 200;

@interface PRDataPicker(){
    UIDatePicker *_datePicker;
    BOOL _canSelectFutrueDate;
}


@end
@implementation PRDataPicker

- (instancetype)initDatePicker:(CGRect)rect defaultDate:(NSDate *)defaultDate selectFutureDate:(BOOL)select{
    if (self = [super initWithFrame:rect]) {
        _date = defaultDate;
        _canSelectFutrueDate = select;
        [self initView];
    }
    return self;
}

-(void)initView{
    NSMutableArray *buttons = [[NSMutableArray alloc]initWithCapacity:2];
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,  200)];
//    [toolbar setBackgroundColor:UIColorFromRGB(0xfbfbfb)];
    [toolbar setBackgroundColor:[UIColor colorWithDisplayP3Red:251 green:251 blue:251 alpha:1] ];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolbarAction:)];
    cancelItem.tag = 1;
    
    UIBarButtonItem *flexibleSpaceItem =[[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                         target:self
                                         action:NULL];
    
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarAction:)];
    doneItem.tag = 2;
    
    [buttons addObject:cancelItem];
    [buttons addObject:flexibleSpaceItem];
    [buttons addObject:doneItem];
    [toolbar setItems:buttons animated:YES];
    [self addSubview:toolbar];
    
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, HEIGHT-40)];
    if (!_date) {
        _date = [NSDate date];
    }
    [_datePicker setDate:_date];
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    if (!_canSelectFutrueDate) {
        [_datePicker setMaximumDate:[NSDate date]];
    }
    
    [self addSubview:_datePicker];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, -3.0f);
    self.layer.shadowOpacity = 0.2f;
}

-(void)toolbarAction:(UIBarButtonItem *)item{
    NSInteger tag = item.tag;
    NSLog(@"action");
    if ([_delegate respondsToSelector:@selector(dateSelected:actionIndex:)]) {
        _date = [_datePicker date];
        [_delegate dateSelected:[_datePicker date] actionIndex:tag];
    }
}

- (void)show{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-HEIGHT, [UIScreen mainScreen].bounds.size.width, HEIGHT);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)dismiss {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];//动画时间长度，单位秒，浮点数
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, HEIGHT);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)animationFinished{
    if ([_delegate respondsToSelector:@selector(animationFinished)]) {
        [_delegate animationFinished];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
