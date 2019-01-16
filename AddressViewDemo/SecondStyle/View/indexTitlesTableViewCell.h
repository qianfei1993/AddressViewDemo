//
//  indexTitlesTableViewCell.h
//  PandaNaughty
//
//  Created by damai on 2018/12/1.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface indexTitlesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidthConstraint;

@end
