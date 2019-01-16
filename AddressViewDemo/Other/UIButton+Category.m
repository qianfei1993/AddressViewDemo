//
//  UIButton+Category.m
//  CustomButton
//
//  Created by damai on 2018/10/25.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

#pragma mark  ———————————按钮文字图片位置————————————

/**
 *  设置图片与文字样式
 *
 *  @param style     图片的文字
 *  @param space     图片与文字之间的间距
 */
- (void)buttonImageStyle:(ButtonImageTitleStyle)style space:(CGFloat)space{
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    labelWidth = self.titleLabel.intrinsicContentSize.width;
    labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case ButtonImageTitleStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case ButtonImageTitleStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonImageTitleStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ButtonImageTitleStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

#pragma mark  ———————————按钮倒计时————————————
- (void)startCountDownWithSeconds:(NSInteger)second{

    NSDate *startDate = [NSDate date];
    NSNumber *number = [NSNumber numberWithInteger:second];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:number,@"second",startDate,@"startDate", nil];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:userInfo repeats:YES];                                                                             
    timer.fireDate = [NSDate distantPast];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerStart:(NSTimer *)timer{
    
    NSDictionary *dict = timer.userInfo;
    NSDate *startDate = dict[@"startDate"];
    NSInteger totalSecond = [dict[@"second"] integerValue];
    self.enabled = NO;
    double deltaTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSInteger second = totalSecond - (NSUInteger)(deltaTime+0.5) ;
    if (second <= 0){
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                self.enabled = YES;
                [timer invalidate];
                second = totalSecond;
                [self setTitle:@"重发短信验证码" forState:UIControlStateNormal];
                [self setTitle:@"重发短信验证码" forState:UIControlStateDisabled];
            }
        }
    }else{
            NSString *title = [NSString stringWithFormat:@"%lds后可重新获取",(long)second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
    }
}


/**
 *  倒计时按钮
 *
 *  @param second    倒计时时间
 *  @param block     倒计时完成block
 */
- (void)startCountDownWithSeconds:(NSInteger)second completeBlock:(countDownCompleteBlock)block{
    
    __block NSInteger tempSecond = second;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (tempSecond <= 1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                block ?  block() : nil;
            });
        } else {
            tempSecond--;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = NO;
                [self setTitleColor:kRGBA(230, 230, 230, 1.0) forState:UIControlStateNormal];
                [self setTitle:[NSString stringWithFormat:@"%lds后可重新获取", (long)tempSecond] forState:UIControlStateNormal];
            });
        }
    });
    dispatch_resume(timer);
}

#pragma mark  ———————————规则圆角按钮————————————
/**
 *  规则圆角按钮
 *  @param radius           圆角半径
 */
- (void)makeCornerRadius:(float)radius{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
/**
 *  规则圆角按钮
 *  @param radius           圆角半径
 *  @param borderWidth      边框宽度
 *  @param borderColor      边框颜色
 */
- (void)makeCornerRadius:(float)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.clipsToBounds = YES;
}

/**
 *  不规则圆角按钮
 *  @param corners          圆角设置
 *  @param radius           圆角半径
 *  @param borderWidth      边框宽度
 *  @param borderColor      边框颜色
 */
- (void)makeCornerRadiusStyle:(UIRectCorner)corners radius:(float)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor{

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *temp = [CAShapeLayer layer];
    temp.lineWidth = borderWidth;
    temp.fillColor = [UIColor clearColor].CGColor;
    temp.strokeColor = borderColor.CGColor;
    temp.frame = self.bounds;
    temp.path = path.CGPath;
    [self.layer addSublayer:temp];
    CAShapeLayer *mask = [[CAShapeLayer alloc]initWithLayer:temp];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

@end
