//
//  RootViewController.m
//  AddressViewDemo
//
//  Created by damai on 2019/1/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "RootViewController.h"
#import "CityViewController.h"
#import "FoldCityViewController.h"
#import "AddressListView.h"
#import "AddressPickerView.h"
@interface RootViewController ()
@property (nonatomic, strong) CityViewController *cityCtrl;
@property (nonatomic, strong) FoldCityViewController *foldCityCtrl;
@property (nonatomic, strong) AddressListView *listView;
@property (nonatomic, strong) AddressPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *foldButton;
@property (weak, nonatomic) IBOutlet UIButton *addressListButton;
@property (weak, nonatomic) IBOutlet UIButton *addressPickerButton;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"城市选择样式";
    __weak typeof(self) weakSelf = self;
    self.cityCtrl = [[CityViewController alloc]init];
    self.cityCtrl.selectCityBlock = ^(NSString *string, NSString *strID) {
        NSLog(@"string = %@\nstrID = %@",string,strID);
        [weakSelf.cityButton setTitle:string forState:UIControlStateNormal];
    };

    self.foldCityCtrl = [[FoldCityViewController alloc]init];
    self.foldCityCtrl.selectCityBlock = ^(NSString *cityName, NSString *areaName) {
        NSLog(@"string = %@\nstrID = %@",cityName,areaName);
        [weakSelf.foldButton setTitle:areaName forState:UIControlStateNormal];
    };
    
    
    self.listView = [[AddressListView alloc]init];
    self.listView.addressBlock = ^(NSString *addressStr, NSString *adcodeStr) {
        NSLog(@"string = %@\nstrID = %@",addressStr,adcodeStr);
        [weakSelf.addressListButton setTitle:addressStr forState:UIControlStateNormal];
    };
    
    self.pickerView = [[AddressPickerView alloc]init];
    self.pickerView.addressBlock = ^(NSString *addressStr, NSString *adcodeStr) {
        NSLog(@"string = %@\nstrID = %@",addressStr,adcodeStr);
        [weakSelf.addressPickerButton setTitle:addressStr forState:UIControlStateNormal];
    };
}

- (IBAction)cityListViewAction:(UIButton *)sender {
    
    [self presentViewController:self.cityCtrl animated:YES completion:nil];
}
- (IBAction)foldButtonAction:(UIButton *)sender {
    
    [self presentViewController:self.foldCityCtrl animated:YES completion:nil];
}

- (IBAction)addressListButtonAction:(UIButton *)sender {
   
    [self.listView show];
}

- (IBAction)addressPickerButtonAction:(UIButton *)sender {
    
    [self.pickerView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
