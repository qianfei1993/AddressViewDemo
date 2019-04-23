//
//  CityModel.h
//
//
//  Created by damai on 2018/8/30.
//  Copyright © 2018年 damai. All rights reserved.

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property(nonatomic,copy)NSString *citycode;
@property(nonatomic,copy)NSString *adcode;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *center;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,strong)NSArray *districts;
@end


@interface CountyModel : NSObject

@property(nonatomic,copy)NSString *citycode;
@property(nonatomic,copy)NSString *adcode;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *center;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,strong)NSArray *districts;
@end


@interface ProvinceModel : NSObject

@property(nonatomic,copy)NSString *citycode;
@property(nonatomic,copy)NSString *adcode;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *center;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,strong)NSArray *districts;
@end
