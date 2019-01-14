//
//  SystemLocationTool.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "SystemLocationTool.h"

@interface SystemLocationTool ()<CLLocationManagerDelegate>

// 定位管理器
@property (strong, nonatomic) CLLocationManager *manager;
// 地理编码和反编码
@property (strong, nonatomic) CLGeocoder *geocoder;
// 所有定位信息
@property (copy, nonatomic) LocationPlacemark locationPlacemark;
// 定位失败
@property (copy, nonatomic) LocationFailed locationFailed;
//判断是否跳转设置,end:是，start:否
@property (nonatomic, copy) NSString *locationState;
@property (nonatomic, strong) UIViewController *viewController;
@end

@implementation SystemLocationTool

static id _instance = nil;
+ (instancetype)sharedInstance {
    
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}

- (void)getLocationViewController:(UIViewController*)viewController Placemark:(LocationPlacemark)placemark didFailWithError:(LocationFailed)error{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (placemark) {
        self.locationPlacemark = placemark;
    }
    if (error) {
        self.locationFailed = error;
    }
    self.viewController = viewController;
    [self locationAction];
}


- (void)locationAction {
    
    // 定位
    self.manager = [CLLocationManager new];
    self.manager.distanceFilter = 10;
    self.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // 2.设置代理
    self.manager.delegate = self;
    
    // 3.请求定位
    //    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    //        [self.manager requestAlwaysAuthorization];
    //    }
    //     只有使用时才访问位置信息
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    // 4.开始定位
    [self.manager startUpdatingLocation];
    // 初始化编码器
    self.geocoder = [CLGeocoder new];
}

#pragma mark -- 地理位置代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations[0];
    // 通常为了节省电量和资源损耗，在获取到位置以后选择停止定位服务
    [self.manager stopUpdatingLocation];
    // 地理反编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = placemarks[0];
        if (self.locationPlacemark) {
            self.locationPlacemark(placeMark);
        }
    }];
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 通常为了节省电量和资源损耗，在获取到位置以后选择停止定位服务
    [self.manager stopUpdatingLocation];
    if (self.locationFailed) {
        self.locationFailed(error);
    }
}

// 定位状态改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if(status == kCLAuthorizationStatusNotDetermined){
        //未决定，继续请求授权
        
    }else if(status == kCLAuthorizationStatusRestricted){
        //受限制，尝试提示然后进入设置页面进行处理（根据API说明一般不会返回该值）
        
    }else if(status == kCLAuthorizationStatusDenied){
        
        //拒绝使用，提示是否进入设置页面进行修改
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务未开启，请在系统设置中开启服务" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.locationState = @"start";
            //进入系统设置页面，APP本身的权限管理页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        
        [self.viewController presentViewController:alertVC animated:YES completion:^{   
        }];
      
    }else if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        //授权使用，不做处理
        
    }else if(status == kCLAuthorizationStatusAuthorizedAlways){
        //始终使用，不做处理
    }
}

- (void)enterForegroundNotification:(NSNotification *)notify {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.locationState && [self.locationState isEqualToString:@"start"]) {
            self.locationState = @"end";
            [self locationAction];
        }
    });
}

-(void)dealloc{
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

@end
