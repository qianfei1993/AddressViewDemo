//
//  CityTableViewCell.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "CityTableViewCell.h"
#define  ScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation CityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cityArray:(NSArray*)array
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        _cityArray =array;
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
        for(int i=0;i<array.count;i++){

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.center = CGPointMake(ScreenWidth/6+(ScreenWidth/3-10)*(i%3), 30+(30+15)*(i/3));
            btn.tag = i;
            btn.bounds = CGRectMake(0, 0, ScreenWidth/3-30, 35);
            [btn setTitleColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1] forState:0];
            
            [btn setTitle:array[i][@"name"] forState:0];
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:btn];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1].CGColor;
        }
    }
    return self;
}
-(void)click:(UIButton *)btn{
    
    if(_cityArray.count==1&btn.tag==0){
        self.didSelectedBtn(99999);
    }else{
        self.didSelectedBtn((int)btn.tag);
    }
}
@end
