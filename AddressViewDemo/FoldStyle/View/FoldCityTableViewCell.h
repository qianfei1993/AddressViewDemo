//
//  CityTableViewCell.h
//  PandaNaughty
//
//  Created by damai on 2018/11/27.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cityNameBlock)(NSString *cityName,NSString *areaName);
typedef void (^titleButtonBlock)(UIButton *button);
@interface FoldCityTableViewCell : UITableViewCell

@property (nonatomic, copy) cityNameBlock nameBlock;
@property (nonatomic, copy) titleButtonBlock block;

@property (nonatomic, strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UICollectionView *cityCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;



@end
