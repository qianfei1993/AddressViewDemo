//
//  AddressPickerView.h
//
//
//  Created by damai on 2018/8/30.
//  Copyright © 2018年 damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPickerView : UIView

/**
 *顶部标题栏高度，默认50
 *
 */
@property (nonatomic,assign)CGFloat topHeight;

/**
 *整体视图高度，默认300;
 *
 */
@property (nonatomic,assign)CGFloat defaultHeight;

/**
 *顶部栏颜色，默认蓝色
 *
 */
@property (nonatomic,strong)UIColor *topColor;
    
//回调
@property(nonatomic,copy) void(^addressBlock)(NSString *addressStr,NSString *adcodeStr);
//显示
-(void)show;

//显示指定
-(void)showSelectProvinceId:(NSString*)provinceId cityId:(NSString*)cityId countyId:(NSString*)countyId;
    
    
@end
