//
//  LoopImageViewController.h
//  Common
//
//  Created by damai on 2018/9/13.
//  Copyright © 2018年 damai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoldCityViewController : UIViewController

@property (nonatomic,copy)void(^selectCityBlock)(NSString *cityName,NSString *areaName);
@property (nonatomic,copy)NSString *currentCityString;

@end
