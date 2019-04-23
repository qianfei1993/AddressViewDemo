//
//  SecondData.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/15.
//  Copyright © 2019 personal. All rights reserved.
//

#import "SecondData.h"
#import "BMChineseSort.h"
#import "SystemLocationTool.h"
#import "NSString+Size.h"
@implementation SecondData

+ (NSArray *)loadJson:(NSString *)jsonName{
    //获取数据
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:jsonName ofType:@"json"];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:&error];
    NSArray *resultArr = [jsonDic objectForKey:@"districts"];
    NSMutableArray *totalArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < resultArr.count ; i++) {
        NSDictionary *provinceDict = resultArr[i];
        NSArray *cityArray = provinceDict[@"districts"];
        if (cityArray.count > 0) {
            for (int j = 0; j < cityArray.count ; j++) {
                NSDictionary *cityDict = cityArray[j];
                [totalArr addObject:cityDict];
            }
        }
    }
    return totalArr.copy;
}

// 数据排序
+ (NSDictionary *)sortData:(NSArray*)array{
    // 排序
    NSMutableDictionary *dict;
    [BMChineseSort sortAndGroup:array key:@"name" finish:^(bool isSuccess, NSMutableArray *unGroupArr, NSMutableArray *sectionTitleArr, NSMutableArray<NSMutableArray *> *sortedObjArr) {
        if (isSuccess) {
            [dict setValue:sortedObjArr forKey:@"sort"];
            [dict setValue:sectionTitleArr forKey:@"index"];
        }
    }];
    return dict.copy;
}

// 热门城市
+ (NSArray *)getHotCity{
    
    NSMutableDictionary *hotCityDict = [NSMutableDictionary dictionary];
    NSArray *hotArr = @[
                        @{@"name":@"上海",@"code":@"code"},
                        @{@"name":@"北京",@"code":@"code"},
                        @{@"name":@"广州",@"code":@"code"},
                        @{@"name":@"武汉",@"code":@"code"},
                        @{@"name":@"深圳",@"code":@"code"},
                        @{@"name":@"杭州",@"code":@"code"},
                        @{@"name":@"成都",@"code":@"code"},
                        @{@"name":@"重庆",@"code":@"code"},
                        @{@"name":@"南京",@"code":@"code"}
                        ];
    [hotCityDict setObject:@"热门城市" forKey:@"name"];
    [hotCityDict setObject:hotArr forKey:@"districts"];
    [hotCityDict setObject:@"citycode" forKey:@"citycode"];
    [hotCityDict setObject:@"adcode" forKey:@"adcode"];
    [hotCityDict setObject:@"center" forKey:@"center"];
    [hotCityDict setObject:@"level" forKey:@"level"];
    return @[hotCityDict];
}

// 定位数据
+ (NSArray *)getLocation:(UIViewController *)ctrl :(LocationBlock)block{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableDictionary *currentCityDict = [NSMutableDictionary dictionary];
    NSArray *curArr = @[
                        @{@"name":@"定位中...",@"code":@"code"}
                        ];
    [currentCityDict setObject:@"定位城市" forKey:@"name"];
    [currentCityDict setObject:curArr forKey:@"districts"];
    [currentCityDict setObject:@"citycode" forKey:@"citycode"];
    [currentCityDict setObject:@"adcode" forKey:@"adcode"];
    [currentCityDict setObject:@"center" forKey:@"center"];
    [currentCityDict setObject:@"level" forKey:@"level"];
    [array addObject:currentCityDict];
    [[SystemLocationTool sharedInstance]getLocationViewController:ctrl Placemark:^(CLPlacemark *placemark) {
        NSString *cityStr = [NSString stringWithFormat:@"%@",placemark.locality];
        NSArray *curArr = @[@{@"name":cityStr,@"code":@"code"}
                            ];
        [currentCityDict setObject:curArr forKey:@"districts"];
        if (block) {
            block();
        }
    } didFailWithError:^(NSError *error) {
        NSString *cityStr = @"定位失败";
        NSArray *curArr = @[@{@"name":cityStr,@"code":@"code"}
                            ];
        [currentCityDict setObject:curArr forKey:@"districts"];
        if (block) {
            block();
        }
    }];
    return array;
}


// 历史记录
+ (NSArray*)getHistoryCity{
    return kUserDefaults_GET_OBJECT(@"cityCache");
}

// 字母
+ (BOOL)isLetter:(NSString*)string{
    
    NSString *tmpRegex = @"^[A-Za-z]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:string];
}
// 汉字
+ (BOOL)isCHZN:(NSString*)string{
    
    NSString *tmpRegex = @"^[\\u4e00-\\u9fa5]+$";
    NSPredicate *tmpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tmpRegex];
    return [tmpTest evaluateWithObject:string];
}

// 计算行数
+ (CGFloat)tableViewCellHeight:(NSArray*)arr{
    
    if (kISNullArray(arr)) {
        return 0;
    }
    CGFloat leftSpace = 0;//左间距
    CGFloat rightSpace = 10;//右间距
    CGFloat viewW = kScreenWidth-46;
    NSUInteger rowNum = arr.count?1:0;
    CGFloat itemX = leftSpace;
    for(int i = 0 ; i < arr.count; i ++ ){
        NSDictionary *dict = arr[i];
        NSString *name = dict[@"name"];
        CGSize size = [name sizeForFont:kFont(14) size:CGSizeMake(kScreenWidth-46, 34) mode:NSLineBreakByWordWrapping];
        CGFloat labelWidth = MIN(kScreenWidth-46-30-30, ceil(size.width));
        CGSize sizee = CGSizeMake(labelWidth + 30 + 30 , 34);
        itemX += sizee.width + leftSpace + rightSpace;
        if(itemX > viewW){
            i--;
            rowNum ++;
            itemX = leftSpace;
        }
    }
    return (rowNum *34) + (rowNum-1)*10 + 5;
}
@end
