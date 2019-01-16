//
//  SecondData.h
//  AddressViewDemo
//
//  Created by damai on 2019/1/15.
//  Copyright © 2019 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^LocationBlock)(void);
@interface SecondData : NSObject
// 加载json
+ (NSArray *)loadJson:(NSString *)jsonName;
// 排序
+ (NSDictionary *)sortData:(NSArray*)array;
// 定位数据
+ (NSArray *)getLocation:(UIViewController *)ctrl :(LocationBlock)block;
// 热门城市
+ (NSArray *)getHotCity;
// 历史记录
+ (NSArray*)getHistoryCity;
// 判断字母
+ (BOOL)isLetter:(NSString*)string;
// 判断汉字
+ (BOOL)isCHZN:(NSString*)string;
// 计算高度
+ (CGFloat)tableViewCellHeight:(NSArray*)arr;
@end
