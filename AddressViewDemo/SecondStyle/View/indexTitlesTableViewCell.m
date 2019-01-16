//
//  indexTitlesTableViewCell.m
//  PandaNaughty
//
//  Created by damai on 2018/12/1.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "indexTitlesTableViewCell.h"

@implementation indexTitlesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.layer.cornerRadius = self.titleLabel.height/2;
    self.titleLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor = [UIColor blueColor];
    }else{
        self.titleLabel.textColor = [UIColor blueColor];;
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
