//
//  TextFieldTool.h
//
//
//  Created by damai on 2018/8/30.
//  Copyright © 2018年 damai. All rights reserved.

#import <UIKit/UIKit.h>



@interface AddressListView : UIView
//回调
@property(nonatomic,copy) void(^addressBlock)(NSString *addressStr,NSString *adcodeStr);

/**
 *顶部标题栏高度，默认50
 *
 */
@property (nonatomic,assign)CGFloat topHeight;

/**
 *单元格高度，默认50
 *
 */
@property (nonatomic,assign)CGFloat cellHeight;

/**
 *整体视图高度，默认400;
 *
 */
@property (nonatomic,assign)CGFloat defaultHeight;

/**
 *选中颜色
 *
 */
@property (nonatomic,strong)UIColor *selectColor;

/**
 *类方法初始化
 *
 */
+(instancetype)store;

/**
 *弹出视图
 *
 */
-(void)show;
@end
