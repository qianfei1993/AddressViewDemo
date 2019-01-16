//
//  UIButton+Category.h
//  CustomButton
//
//  Created by damai on 2018/10/25.
//  Copyright © 2018年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^countDownCompleteBlock)(void);
typedef NS_ENUM(NSUInteger, ButtonImageTitleStyle) {
    ButtonImageTitleStyleLeft, // image在左
    ButtonImageTitleStyleRight, // image在右
    ButtonImageTitleStyleTop, // image在上
    ButtonImageTitleStyleBottom, // image在
};
@interface UIButton (Category)

/**
 *  设置图片与文字样式
 *
 *  @param style     图片的文字
 *  @param space     图片与文字之间的间距
 */
- (void)buttonImageStyle:(ButtonImageTitleStyle)style space:(CGFloat)space;


/**
 *  倒计时按钮
 *
 *  @param second    倒计时时间
 */
- (void)startCountDownWithSeconds:(NSInteger)second;

/**
 *  倒计时按钮
 *
 *  @param second    倒计时时间
 *  @param block     倒计时完成block
 */
- (void)startCountDownWithSeconds:(NSInteger)second completeBlock:(countDownCompleteBlock)block;

/**
 *  规则圆角按钮
 *  @param radius           圆角半径
 */
- (void)makeCornerRadius:(float)radius;

/**
 *  规则圆角按钮
 *  @param radius           圆角半径
 *  @param borderWidth      边框宽度
 *  @param borderColor      边框颜色
 */
- (void)makeCornerRadius:(float)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;

/**
 *  不规则圆角按钮
 *  @param corners          圆角设置
 *  @param radius           圆角半径
 *  @param borderWidth      边框宽度
 *  @param borderColor      边框颜色
 */
- (void)makeCornerRadiusStyle:(UIRectCorner)corners radius:(float)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
@end
