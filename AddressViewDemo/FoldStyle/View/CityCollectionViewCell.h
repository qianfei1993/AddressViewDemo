//
//  CityCollectionViewCell.h
//  PandaNaughty
//
//  Created by damai on 2018/11/27.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
