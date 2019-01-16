//
//  myView.h
//
//
//  Created by pro on 16/5/26.
//  Copyright (c) 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface myView : NSObject

+(UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag tintColor:(UIColor *)tintColor backgroundColor:(UIColor *)backgroundColor;

@end
