//
//  ResultCityController.h
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ResultCityControllerDelegate <NSObject>

-(void)didScroll;
-(void)didSelectedString:(NSString *)string :(NSString *)strID;

@end

@interface ResultCityController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,assign) id <ResultCityControllerDelegate>delegate;
@end
