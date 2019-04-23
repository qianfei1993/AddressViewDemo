//
//  CityCollectionViewCell.m
//  PandaNaughty
//
//  Created by damai on 2018/11/27.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "CityCollectionViewCell.h"

@implementation CityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.layer.cornerRadius = self.titleLabel.height/2;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.layer.borderColor = kRGBA(235, 235, 235, 1.0).CGColor;
    self.titleLabel.clipsToBounds = YES;
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.titleLabel.text = kStringFormat(@"%@",dict[@"name"]);
    self.titleLabel.backgroundColor = kRGBA(253, 253, 253, 1.0);
}
@end
